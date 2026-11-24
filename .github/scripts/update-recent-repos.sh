#!/usr/bin/env bash
# Regenerates the repository index in README.md (between the RECENT markers).
# Run locally or from the update-recent workflow. Requires curl, jq, python3.
set -euo pipefail

OWNER="${GITHUB_REPOSITORY_OWNER:-adrienbrault}"
LIMIT="${LIMIT:-20}"
README="${README:-README.md}"

# Language chip colours (GitHub linguist) and simpleicons slugs. Unknown languages
# fall back to a grey chip without a logo.
LANGS='{
  "Python":     {"c": "3776AB", "l": "python"},
  "TypeScript": {"c": "3178C6", "l": "typescript"},
  "Rust":       {"c": "000000", "l": "rust"},
  "PHP":        {"c": "777BB4", "l": "php"},
  "JavaScript": {"c": "F7DF1E", "l": "javascript"},
  "HTML":       {"c": "E34C26", "l": "html5"},
  "Astro":      {"c": "FF5A03", "l": ""},
  "Makefile":   {"c": "427819", "l": ""},
  "Shell":      {"c": "89E051", "l": "gnubash"}
}'

auth=()
if [ -n "${GITHUB_TOKEN:-}" ]; then
  auth=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

api="https://api.github.com/users/${OWNER}/repos?per_page=100&sort=pushed&type=owner"
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# One bullet per repo: linked name, language chip, small meta caption, description.
# Repos without a description render as the name + meta line only.
curl -fsS "${auth[@]}" -H "Accept: application/vnd.github+json" "$api" |
  jq -r --arg owner "$OWNER" --argjson limit "$LIMIT" --argjson langs "$LANGS" '
    [ .[] | select(.fork == false) | select(.name != $owner) ]
    | sort_by(.pushed_at) | reverse | .[:$limit]
    | .[]
    | (.language // "") as $lang
    | ($langs[$lang] // null) as $style
    | "- **[\(.name)](https://github.com/\($owner)/\(.name))**"
      + (if $lang == "" then ""
         else " ![\($lang)](https://img.shields.io/badge/-\($lang)-"
              + (if $style then $style.c else "555555" end)
              + "?style=flat-square"
              + (if $style and $style.l != "" then "&logo=\($style.l)&logoColor=white" else "" end)
              + ")"
         end)
      + " <sub>"
      + ([ (if .stargazers_count > 0 then "★ \(.stargazers_count)" else empty end),
           (.pushed_at | split("T")[0]) ]
         | join(" · "))
      + "</sub>"
      + (if ((.description // "") | length) == 0 then ""
         else "<br>" + (.description
           | gsub("[\r\n\t]+"; " ")
           | if length > 140 then (.[0:140] | sub("[^ ]*$"; "") | sub(" +$"; "")) + "…"
             else . end)
         end)
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

block = "\n".join([start_marker, "", *items, "", end_marker])
readme.write_text(text[:start] + block + text[end + len(end_marker):])
PY
