# Add yourself some shortcuts to projects you often work on
# Example:
#
# brainstormr=/Users/robbyrussell/Projects/development/planetargon/brainstormr
#
alias ding="say 'all done' &"
alias dru='drush use `git config --get drush.alias`'
alias ddrush='docker-compose exec --user 0 php drush -r ./docroot $*'
alias ddrusha='docker-compose exec --user 82 php drush $*'
# New Vagrant Project
alias nvp='git clone git@github.com:Lullabot/trusty32-lamp.git'

function tt() {
	if [[ -z $1 ]]; then
		echo "You must pass a pull request id."
		return 23
	fi
	ssh cisco.tugboat.qa "tugboat test $1"
}
