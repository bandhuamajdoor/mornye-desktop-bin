
#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(realpath "$0")")"

# Ensure we're in the correct Git repository and branch.
git rev-parse --is-inside-work-tree >/dev/null

branch="$(git branch --show-current)"
if [[ "$branch" != "main" ]]; then
    echo "Error: expected branch 'main', found '$branch'."
    exit 1
fi

# Avoid overwriting local changes.
if [[ -n "$(git status --porcelain)" ]]; then
    echo "Error: working tree isn't clean. Commit or stash your changes first."
    exit 1
fi

repo="mornyeapp/Mornye-Desktop"
tag="$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | jq -er '.tag_name')"
version="${tag#v}"

if [[ ! "$version" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
    echo "Error: unexpected upstream release tag: $tag"
    exit 1
fi

current="$(sed -n 's/^pkgver=//p' PKGBUILD)"

if [[ "$version" == "$current" ]]; then
    echo "Already up to date: $current"
    exit 0
fi

if ! vercmp "$version" "$current" | grep -qx '1'; then
    echo "Error: upstream version $version isn't newer than $current."
    exit 1
fi

echo "Updating Mornye: $current -> $version"

# Update package version and reset release number.
sed -i \
    -e "s/^pkgver=.*/pkgver=$version/" \
    -e 's/^pkgrel=.*/pkgrel=1/' \
    PKGBUILD

# Refresh checksums and verify the release source.
updpkgsums PKGBUILD
makepkg --verifysource

# Build and generate repository metadata.
makepkg -f
makepkg --printsrcinfo > .SRCINFO

# Check for whitespace errors.
git diff --check

echo
echo "Build succeeded. Review and test the package before publishing."
read -r -p "Commit and push this update? [y/N] " answer

if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "Update built but not committed. Review the working tree."
    exit 0
fi

git add PKGBUILD .SRCINFO

if ! git diff --cached --quiet; then
    git commit -m "Update Mornye to $version"
    git push origin main
    echo "Successfully pushed Mornye $version to GitHub."
else
    echo "No packaging changes to commit."
fi
