#!/usr/bin/env bash
# Regenerates the repository index in README.md (between the RECENT markers).
# Run locally or from the update-recent workflow. Requires curl, jq, python3.
set -euo pipefail

OWNER="${GITHUB_REPOSITORY_OWNER:-adrienbrault}"
# Repositories shown expanded; everything up to LIMIT goes behind a <details>.
PRIMARY="${PRIMARY:-10}"
LIMIT="${LIMIT:-20}"
README="${README:-README.md}"

auth=()
if [ -n "${GITHUB_TOKEN:-}" ]; then
  auth=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

api="https://api.github.com/users/${OWNER}/repos?per_page=100&sort=pushed&type=owner"
tmp_raw=$(mktemp)
tmp_primary=$(mktemp)
tmp_more=$(mktemp)
trap 'rm -f "$tmp_raw" "$tmp_primary" "$tmp_more"' EXIT

# One row per repo: linked name with the description beneath, and a right-aligned
# column holding stars and update date stacked. Dates use non-breaking hyphens so
# the narrow column cannot wrap them.
rows_filter='
    [ .[] | select(.fork == false) | select(.name != $owner) ]
    | sort_by(.pushed_at) | reverse
    | .[$from:$to]
    | .[]
    | "| **[\(.name)](https://github.com/\($owner)/\(.name))**"
      + (if ((.description // "") | length) == 0 then ""
         else "<br>" + (.description
           | gsub("[\r\n\t]+"; " ")
           | gsub("\\|"; "\\|")
           | if length > 160 then (.[0:160] | sub("[^ ]*$"; "") | sub(" +$"; "")) + "…"
             else . end)
         end)
      + " | <sub>"
      + ([ (if .stargazers_count > 0 then "\(.stargazers_count) ★" else empty end),
           (.pushed_at | split("T")[0] | gsub("-"; "&#8209;")) ]
         | join("<br>"))
      + "</sub> |"'

curl -fsS "${auth[@]}" -H "Accept: application/vnd.github+json" "$api" > "$tmp_raw"

jq -r --arg owner "$OWNER" --argjson from 0 --argjson to "$PRIMARY" "$rows_filter" \
  "$tmp_raw" > "$tmp_primary"
jq -r --arg owner "$OWNER" --argjson from "$PRIMARY" --argjson to "$LIMIT" "$rows_filter" \
  "$tmp_raw" > "$tmp_more"

python3 - "$README" "$tmp_primary" "$tmp_more" <<'PY'
import pathlib, sys

readme = pathlib.Path(sys.argv[1])
primary = [l for l in pathlib.Path(sys.argv[2]).read_text().splitlines() if l.strip()]
more = [l for l in pathlib.Path(sys.argv[3]).read_text().splitlines() if l.strip()]

start_marker, end_marker = "<!-- RECENT:START -->", "<!-- RECENT:END -->"
text = readme.read_text()
start, end = text.find(start_marker), text.find(end_marker)
if start == -1 or end == -1:
    sys.exit("markers not found in README")

header = ["| Repository | ★<br>updated |", "| :--- | ---: |"]
lines = [start_marker, "", *header, *primary]
if more:
    lines += [
        "",
        "<details>",
        f"<summary>{len(more)} more repositories</summary>",
        "",
        *header,
        *more,
        "",
        "</details>",
    ]
lines += ["", end_marker]

readme.write_text(text[:start] + "\n".join(lines) + text[end + len(end_marker):])
PY
