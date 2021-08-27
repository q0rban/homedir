#!/usr/bin/env bash
set -euo pipefail

# Output an error to STDERR.
echoerr() { echo "$@" 1>&2; }

# Displays the help for this command. Type `git drush --help`
help() {
	printf "\nThis command generates a CHANGELOG entry for a Tugboat release."
	printf "\n  To show this help:\n"
	echo '    $ git tugboat-changelog help'
}

arg1=${1:-}

# Display the help.
if [[ $arg1 = "help" ]]; then
	help
	exit
fi

if [[ "$(git rev-parse --abbrev-ref HEAD)" != "main" ]]; then
  echoerr "You must check out the main branch"
  exit 23
fi

git fetch --quiet origin main
if ! git diff-index --quiet origin/main; then
  echoerr "There are differences between your local checkout and origin. Maybe you need to git pull or git stash?"
  exit 23
fi

today=$(date +'%d %B, %Y')
read -ep "Specify the date for the release. Leave blank to use '$today' > " date
if [[ -z "$date" ]]; then
  date="$today"
fi

npm_version=$(node -p "require('./package.json').version" | sed -e "s/-dev$//")
read -ep "Specify the tag name. Leave blank to use '$npm_version' > " tag
if [[ -z "$tag" ]]; then
  tag="v$npm_version"
fi

printf '\n\n## %s - %s\n\n' "$tag" "$date"
git --no-pager log --reverse --merges --format='* %s' "$(git describe --tags --abbrev=0)..HEAD" 2>/dev/null |
  sed -e 's@Merge\ pull\ request\ #[0-9]\+ from Lullabot/@@g'
      # not working
      #-e 's@\([0-9]{3,}\)@#\1 \0@g'
printf '\n\n'

printf "Next steps:\n"
printf "  1. Run git checkout -b release/%s\n" "$tag"
printf "  2. Edit CHANGELOG\n"
printf "  3. Add the above entry\n"
printf "  4. Run git add CHANGELOG\n"
printf "  5. Change the version in package.json to %s\n" "$npm_version"
printf "  6. Run git add package.json\n"
printf "  7. Run git commit -m '%s'\n" "$tag"
printf "  8. Run git push -u and create a pull request\n"

# Try some of the above commands but don't fail if they fail.
set +e
sed -e "s/\"$npm_version-dev\",/\"$npm_version\",/" -i package.json
git checkout -b release/$tag
