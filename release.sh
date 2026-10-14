#!/usr/bin/env bash
# This script fetches binary release versions from the
# global SurrealDB downloads repository, along with the
# hashes of the release files, and writes them into the
# formulae in this tap.
#
# Formula/surreal.rb installs the CLI, `surreal`, and is
# versioned by it. The CLI installs the database itself.
#
#   ./release.sh                   the CLI to its latest release, and the nightly
#   ./release.sh launcher v0.2.0   the CLI to v0.2.0, and the nightly
#   ./release.sh v3.3.4            as with no argument
#
# The last form is how the database's release pipeline
# calls this script, naming the database version. The
# formula no longer carries the database, so that version
# is ignored, and the CLI is brought up to its latest
# release instead: the pipeline then opens a bump only if
# the CLI has moved since the formula was last bumped.

set -euo pipefail

BASE="https://download.surrealdb.com"

fetch() {
	curl --silent --fail --location "$1"
}

# The SHA-256 published beside an asset, refusing anything that is not one
sha() {
	local hash
	hash=$(fetch "$1" | tr -d '[:space:]')
	if [[ ! "$hash" =~ ^[0-9a-f]{64}$ ]]; then
		echo "error: no SHA-256 at $1" >&2
		exit 1
	fi
	echo "$hash"
}

case "${1:-}" in
	launcher)
		CLI_VERSION="${2:?usage: release.sh launcher v<version>}"
		;;
	"")
		CLI_VERSION=$(fetch "$BASE/cli/launcher/latest.txt")
		;;
	*)
		echo "The surreal formula no longer carries the database; ignoring $1 and bringing the CLI to its latest release." >&2
		CLI_VERSION=$(fetch "$BASE/cli/launcher/latest.txt")
		;;
esac

CLI_VERSION=$(echo "$CLI_VERSION" | tr -d '[:space:]')

# ----------------------------------------
# Nightly
# ----------------------------------------

# Fetch the homebrew nightly template file
TEMPLATE=$(cat nightly.rb)
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{VERSION}/nightly/g")

# Save the nightly template to the file
echo "$TEMPLATE" > Formula/surreal-nightly.rb

# ----------------------------------------
# Release
# ----------------------------------------

# Fetch the homebrew release template file
TEMPLATE=$(cat release.rb)
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{CLI_RELEASE}/${CLI_VERSION#v}/g")
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{CLI_VERSION}/$CLI_VERSION/g")

for PLATFORM in darwin-arm64 darwin-amd64 linux-arm64 linux-amd64; do
	PLATFORM_KEY=$(echo "$PLATFORM" | tr '[:lower:]-' '[:upper:]_')
	CLI_HASH=$(sha "$BASE/cli/launcher/$CLI_VERSION/surreal-$CLI_VERSION.$PLATFORM.txt")
	TEMPLATE=$(echo "$TEMPLATE" | sed "s/{CLI_$PLATFORM_KEY}/$CLI_HASH/g")
done

# Save the release template to the file
echo "$TEMPLATE" > Formula/surreal.rb

# ----------------------------------------
# Commit
# ----------------------------------------

# When SKIP_GIT is set (e.g. from the release pipeline), only regenerate the
# formula files and let the caller create the branch, commit and pull request.
# Manual runs leave SKIP_GIT unset and commit + push directly, as before.
if [ -z "${SKIP_GIT:-}" ]; then

	# Add all changed files to the git commit
	git add --all

	# Commit the new release to the repository
	git commit -m "Upgrade to the CLI ${CLI_VERSION}"

	# Deploy the latest release to Github
	git push

fi
