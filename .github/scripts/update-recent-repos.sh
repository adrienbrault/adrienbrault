#!/usr/bin/env bash
# Regenerates the "Recently updated repositories" table in README.md.
# Run locally or from the update-recent workflow. Requires curl, jq, python3.
set -euo pipefail

OWNER="${GITHUB_REPOSITORY_OWNER:-adrienbrault}"
LIMIT="${LIMIT:-15}"
README="${README:-README.md}"

auth=()
if [ -n "${GITHUB_TOKEN:-}" ]; then
  auth=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

api="https://api.github.com/users/${OWNER}/repos?per_page=100&sort=pushed&type=owner"
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# Build the table rows.
curl -fsS "${auth[@]}" -H "Accept: application/vnd.github+json" "$api" |
  jq -r --arg owner "$OWNER" --argjson limit "$LIMIT" '
    [ .[] | select(.fork == false) | select(.name != $owner) ]
    | sort_by(.pushed_at) | reverse | .[:$limit]
    | .[]
    | "| [\(.name)](https://github.com/\($owner)/\(.name)) | "
      + ((.description // "")
          | gsub("[\r\n\t]+"; " ")
          | gsub("\\|"; "\\|")
          | if length > 110 then .[0:109] + "…" else . end
          | if . == "" then "—" else . end)
      + " | " + (.pushed_at | split("T")[0]) + " |"
  ' > "$tmp"

python3 - "$README" "$tmp" <<'PY'
import pathlib, sys

readme = pathlib.Path(sys.argv[1])
rows = pathlib.Path(sys.argv[2]).read_text().strip().splitlines()

start_marker, end_marker = "<!-- RECENT:START -->", "<!-- RECENT:END -->"
text = readme.read_text()
start, end = text.find(start_marker), text.find(end_marker)
if start == -1 or end == -1:
    sys.exit("markers not found in README")

header = ["", "| Repository | Description | Updated |", "| --- | --- | --- |"]
block = "\n".join([start_marker, *header, *rows, "", end_marker])
readme.write_text(text[:start] + block + text[end + len(end_marker):])
PY
