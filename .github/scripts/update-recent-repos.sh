#!/usr/bin/env bash
# Regenerates the repository index in README.md (between the RECENT markers).
# Run locally or from the update-recent workflow. Requires curl, jq, python3.
set -euo pipefail

OWNER="${GITHUB_REPOSITORY_OWNER:-adrienbrault}"
LIMIT="${LIMIT:-20}"
README="${README:-README.md}"

auth=()
if [ -n "${GITHUB_TOKEN:-}" ]; then
  auth=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

api="https://api.github.com/users/${OWNER}/repos?per_page=100&sort=pushed&type=owner"
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# One bullet per repo: linked name, star pill (only when starred), small date
# caption, description below. Repos without a description render as the name +
# meta line only.
curl -fsS "${auth[@]}" -H "Accept: application/vnd.github+json" "$api" |
  jq -r --arg owner "$OWNER" --argjson limit "$LIMIT" '
    [ .[] | select(.fork == false) | select(.name != $owner) ]
    | sort_by(.pushed_at) | reverse | .[:$limit]
    | .[]
    | "| **[\(.name)](https://github.com/\($owner)/\(.name))**"
      + " <sub>"
      + ([ (if .stargazers_count > 0 then "★ \(.stargazers_count)" else empty end),
           (.pushed_at | split("T")[0]) ]
         | join(" · "))
      + "</sub>"
      + (if ((.description // "") | length) == 0 then ""
         else "<br>" + (.description
           | gsub("[\r\n\t]+"; " ")
           | gsub("\\|"; "\\|")
           | if length > 160 then (.[0:160] | sub("[^ ]*$"; "") | sub(" +$"; "")) + "…"
             else . end)
         end)
      + " |"
  ' > "$tmp"

python3 - "$README" "$tmp" <<'PY'
import pathlib, sys

readme = pathlib.Path(sys.argv[1])
items = [line for line in pathlib.Path(sys.argv[2]).read_text().splitlines() if line.strip()]

start_marker, end_marker = "<!-- RECENT:START -->", "<!-- RECENT:END -->"
text = readme.read_text()
start, end = text.find(start_marker), text.find(end_marker)
if start == -1 or end == -1:
    sys.exit("markers not found in README")

block = "\n".join([start_marker, "", "| Repository |", "| :--- |", *items, "", end_marker])
readme.write_text(text[:start] + block + text[end + len(end_marker):])
PY
