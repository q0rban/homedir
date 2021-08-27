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


# Lullabot / Tugboat servers ssh
alias tm1="ss manager1"
alias tm2="ss manager2"
alias tm3="ss manager3"
alias tw1="ss worker1"
alias tw2="ss worker2"
alias tw3="ss worker3"
alias tw4="ss worker4"
alias tw5="ss worker5"
alias tw6="ss worker6"
alias to="ss ops"
alias lo="ss ops.lullabot.com"
alias tv="ss vpn"
alias lv="ss vpn.lullabot.com"
alias tt="ss test"
alias tsm1="ss manager1.stage.tugboat.qa"
alias tsm2="ss manager2.stage.tugboat.qa"
alias tsm3="ss manager3.stage.tugboat.qa"
alias t1x='ss 1xinternet.tugboat.qa'

# SSH to a host and su as root.
export ss() {
  if [[ -z "$1" ]]; then
    echo "You must pass the hostname to ssh with sudo to." 1>&2;
    return 23
  fi
  # Assume a tugboat.qa subdomain if there's no .
  if (echo "$1" | grep -v \\. > /dev/null); then
    1="${1}.tugboat.qa"
  fi
  (
    set -x
    ssh -t $1 "sudo su -"
  )
}

