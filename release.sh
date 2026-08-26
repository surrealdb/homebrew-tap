# This script fetches the latest binary release
# version from the global SurrealDB downloads
# repository, along with the hash of the release
# file. It then uploads the latest release to
# the homebrew tap repository.

# ----------------------------------------
# Nightly
# ----------------------------------------

# Get the latest release version identifier
VERSION="nightly"

# Get the latest release version file hash
VERHASH=$(curl --silent --fail --location "https://download.surrealdb.com/${VERSION}/surreal-${VERSION}.darwin-universal.txt")

# Fetch the homebrew release template file
TEMPLATE=$(cat templates/nightly.rb.tmpl)
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{VERSION}/$VERSION/g")
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{VERHASH}/$VERHASH/g")

# Save the release template to the file
echo "$TEMPLATE" > Formula/surreal-nightly.rb

# ----------------------------------------
# Release
# ----------------------------------------

# Get the latest release version identifier. An explicit version may be passed
# as the first argument (e.g. "v3.1.5") so the release pipeline can pin the
# exact release instead of trusting the global "latest" pointer; with no
# argument it falls back to that pointer, as manual runs do.
VERSION="${1:-$(curl --silent --fail --location "https://version.surrealdb.com")}"

# Get the latest release version file hash
VERHASH=$(curl --silent --fail --location "https://download.surrealdb.com/${VERSION}/surreal-${VERSION}.darwin-universal.txt")

# Get the latest release version without the preceding 'v'
RELEASE="${VERSION:1}"

# Fetch the homebrew release template file
TEMPLATE=$(cat templates/release.rb.tmpl)
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{RELEASE}/$RELEASE/g")
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{VERSION}/$VERSION/g")
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{VERHASH}/$VERHASH/g")

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
	git commit -m "Upgrade to ${VERSION}"

	# Deploy the latest release to Github
	git push

fi
