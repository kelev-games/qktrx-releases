#!/usr/bin/env bash
set -euo pipefail

repo=kelev-games/qktrx-releases
version="${RELEASE_VERSION:?}"
run_id="${PRODUCER_RUN:?}"
attempt="${ARCHIVE_ATTEMPT:?}"
manifest_hash="${MANIFEST_SHA256:?}"
qa="${QA_EVIDENCE:?}"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*)?$ ]]
[[ "$run_id" =~ ^[1-9][0-9]*$ && "$attempt" =~ ^[1-9][0-9]*$ && "$manifest_hash" =~ ^[a-f0-9]{64}$ ]]
[[ "$qa" =~ ^https://github\.com/kelev-games/qktrx/actions/runs/[1-9][0-9]*$ ]]

dir="$(mktemp -d "${RUNNER_TEMP:?}/qktrx-macos.XXXXXXXX")"
cd "$dir"
prefix="gs://kg-qktrx-dev-releases-1060876531541/qktrx/macos-arm64/$version/$run_id/$attempt"
base="qktrx-$version-darwin-arm64"
tag="v$version"
sha256() { sha256sum < "$1" | awk '{print $1}'; }
file_size() { wc -c < "$1" | tr -d '[:space:]'; }

gcloud storage cat "$prefix/manifest.json" > manifest.json
[[ "$(sha256 manifest.json)" = "$manifest_hash" ]]
jq -e --arg version "$version" --arg run "$run_id" --arg attempt "$attempt" \
  --arg base "$base" '
  def artifact($filename):
    .filename == $filename and (.sha256 | test("^[a-f0-9]{64}$")) and
    (.bytes | type == "number" and floor == . and . > 0 and . <= 1073741824);
  .schemaVersion == 1 and .platform == "darwin" and .architecture == "arm64" and
  .version == $version and .runId == $run and .runAttempt == $attempt and
  (.sourceCommit | test("^[a-f0-9]{40}$")) and
  (.artifacts.dmg | artifact($base + ".dmg")) and
  (.artifacts.zip | artifact($base + ".zip"))
' manifest.json >/dev/null

for kind in dmg zip; do
  file="$base.$kind"
  gcloud storage cat "$prefix/$file" > "$file"
  [[ "$(sha256 "$file")" = "$(jq -r --arg kind "$kind" '.artifacts[$kind].sha256' manifest.json)" ]]
  [[ "$(file_size "$file")" = "$(jq -r --arg kind "$kind" '.artifacts[$kind].bytes' manifest.json)" ]]
done
printf '%s  %s\n' "$(sha256 "$base.dmg")" "$base.dmg" \
  "$(sha256 "$base.zip")" "$base.zip" "$manifest_hash" manifest.json > SHA256SUMS
printf '%s\n\nManifest SHA-256: `%s`\n' "${RELEASE_NOTES:?}" "$manifest_hash" > notes.md
# The private QA run is recorded in this workflow's approval trail, not in the
# public release notes.
printf 'QA evidence: %s\nManifest SHA-256: %s\n' "$qa" "$manifest_hash" >> "${GITHUB_STEP_SUMMARY:?}"

mode=()
if [[ "$version" == *-* ]]; then mode+=(--prerelease); fi
# Work in a draft until the hosted hashes match. A retry can resume only the
# draft bound to this exact manifest and cannot replace an existing asset.
if ! gh release view "$tag" -R "$repo" --json body,isDraft,assets > hosted.json; then
  gh release create "$tag" -R "$repo" --target "${GITHUB_SHA:?}" --draft --latest=false \
    --title "qktrx $version" --notes-file notes.md "${mode[@]}"
  gh release view "$tag" -R "$repo" --json body,isDraft,assets > hosted.json
fi
jq -e --arg digest "$manifest_hash" '.body | contains("Manifest SHA-256: `" + $digest + "`")' hosted.json >/dev/null
files=("$base.dmg" "$base.zip" manifest.json SHA256SUMS)
for file in "${files[@]}"; do
  if ! jq -e --arg file "$file" '.assets | any(.name == $file)' hosted.json >/dev/null; then
    jq -e '.isDraft' hosted.json >/dev/null
    gh release upload "$tag" -R "$repo" "$file"
  fi
done

verify_assets() {
  gh release view "$tag" -R "$repo" --json isDraft,assets > hosted.json
  jq -e '.assets | length == 4' hosted.json >/dev/null
  for file in "${files[@]}"; do
    jq -e --arg name "$file" --arg digest "sha256:$(sha256 "$file")" \
      --argjson bytes "$(file_size "$file")" '
      .assets | any(.name == $name and .digest == $digest and .size == $bytes and .state == "uploaded")
    ' hosted.json >/dev/null
  done
}
verify_assets
if jq -e '.isDraft' hosted.json >/dev/null; then
  gh release edit "$tag" -R "$repo" --draft=false --latest=false --notes-file notes.md
fi
verify_assets
jq -e '.isDraft == false' hosted.json >/dev/null
printf '[Published qktrx %s](https://github.com/%s/releases/tag/%s)\n' "$version" "$repo" "$tag" >> "$GITHUB_STEP_SUMMARY"
