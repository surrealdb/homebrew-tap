#!/usr/bin/env bash
# This script fetches binary release versions from the
# global SurrealDB downloads repository, along with the
# hashes of the release files, and writes them into the
# formulae in this tap, from the templates in templates/.
#
# Formula/surreal.rb is the CLI, `surreal`, versioned by
# the CLI. Formula/surreal-db.rb is the database alone, as
# `surreal-db`, versioned by the database.
#
#   ./release.sh                   both to their latest releases
#   ./release.sh v3.3.4            the database to v3.3.4
#   ./release.sh db v3.3.4         the same
#   ./release.sh launcher v0.2.0   the CLI to v0.2.0
#
# A bare version is the database's: that is how the
# database's release pipeline calls this script.

set -euo pipefail

BASE="https://download.surrealdb.com"
PLATFORMS="darwin-arm64 darwin-amd64 linux-arm64 linux-amd64"

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

# The key a platform's hash is filled in under: darwin-arm64 is DARWIN_ARM64
platform_key() {
	echo "$1" | tr '[:lower:]-' '[:upper:]_'
}

DB_VERSION=""
CLI_VERSION=""

case "${1:-}" in
	"")
		DB_VERSION=$(fetch "https://version.surrealdb.com")
		CLI_VERSION=$(fetch "$BASE/cli/launcher/latest.txt")
		;;
	db)
		DB_VERSION="${2:?usage: release.sh db v<version>}"
		;;
	launcher)
		CLI_VERSION="${2:?usage: release.sh launcher v<version>}"
		;;
	*)
		DB_VERSION="$1"
		;;
esac

DB_VERSION=$(echo "$DB_VERSION" | tr -d '[:space:]')
CLI_VERSION=$(echo "$CLI_VERSION" | tr -d '[:space:]')

# ----------------------------------------
# Database
# ----------------------------------------

if [ -n "$DB_VERSION" ]; then

	# Fetch the homebrew database template file
	TEMPLATE=$(cat templates/surreal-db.rb.tmpl)
	TEMPLATE=$(echo "$TEMPLATE" | sed "s/{DB_RELEASE}/${DB_VERSION#v}/g")
	TEMPLATE=$(echo "$TEMPLATE" | sed "s/{DB_VERSION}/$DB_VERSION/g")

	for PLATFORM in $PLATFORMS; do
		HASH=$(sha "$BASE/$DB_VERSION/surreal-$DB_VERSION.$PLATFORM.txt")
		TEMPLATE=$(echo "$TEMPLATE" | sed "s/{DB_$(platform_key "$PLATFORM")}/$HASH/g")
	done

	# Save the database template to the file
	echo "$TEMPLATE" > Formula/surreal-db.rb

fi

# ----------------------------------------
# CLI
# ----------------------------------------

if [ -n "$CLI_VERSION" ]; then

	# Fetch the homebrew CLI template file
	TEMPLATE=$(cat templates/surreal.rb.tmpl)
	TEMPLATE=$(echo "$TEMPLATE" | sed "s/{CLI_RELEASE}/${CLI_VERSION#v}/g")
	TEMPLATE=$(echo "$TEMPLATE" | sed "s/{CLI_VERSION}/$CLI_VERSION/g")

	for PLATFORM in $PLATFORMS; do
		HASH=$(sha "$BASE/cli/launcher/$CLI_VERSION/surreal-$CLI_VERSION.$PLATFORM.txt")
		TEMPLATE=$(echo "$TEMPLATE" | sed "s/{CLI_$(platform_key "$PLATFORM")}/$HASH/g")
	done

	# Save the CLI template to the file
	echo "$TEMPLATE" > Formula/surreal.rb

fi

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
	git commit -m "Upgrade to${DB_VERSION:+ surreal-db $DB_VERSION}${CLI_VERSION:+ surreal $CLI_VERSION}"

	# Deploy the latest release to Github
	git push

fi
