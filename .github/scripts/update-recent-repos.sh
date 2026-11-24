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

# One card per repo: bold linked name, small meta line, description.
# Repos without a description render as name + meta only.
curl -fsS "${auth[@]}" -H "Accept: application/vnd.github+json" "$api" |
  jq -r --arg owner "$OWNER" --argjson limit "$LIMIT" '
    [ .[] | select(.fork == false) | select(.name != $owner) ]
    | sort_by(.pushed_at) | reverse | .[:$limit]
    | .[]
    | "**[\(.name)](https://github.com/\($owner)/\(.name))**<br>"
      + "<sub>"
        + ([ (.language // empty),
             (if .stargazers_count > 0 then "★ \(.stargazers_count)" else empty end),
             (.pushed_at | split("T")[0]) ]
           | join(" · "))
        + "</sub>"
      + (if (.description // "") == "" then "" else
          "<br>" + (.description
            | gsub("[\r\n\t]+"; " ")
            | if length > 140 then .[0:139] + "…" else . end)
         end),
      ""
  ' > "$tmp"

python3 - "$README" "$tmp" <<'PY'
import pathlib, sys

readme = pathlib.Path(sys.argv[1])
cards = [b.strip() for b in pathlib.Path(sys.argv[2]).read_text().strip().split("\n\n") if b.strip()]

start_marker, end_marker = "<!-- RECENT:START -->", "<!-- RECENT:END -->"
text = readme.read_text()
start, end = text.find(start_marker), text.find(end_marker)
if start == -1 or end == -1:
    sys.exit("markers not found in README")

block = "\n\n".join([start_marker, *cards, "", end_marker])
readme.write_text(text[:start] + block + text[end + len(end_marker):])
PY
