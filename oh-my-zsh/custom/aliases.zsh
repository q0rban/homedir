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

alias tugboat-down='ssh -t irongoat.local "sudo shutdown now"'
export tugboat-up() {
  wakeonlan 54:b2:03:83:97:56
  printf "Waiting for sshd to start."
  while ! nc -z irongoat.local 22 &> /dev/null; do
    sleep 1;
    printf "."
  done
  printf "\nReady for connections!\n"
}
alias tugboat-ssh="tugboat-up && ssh irongoat.local"

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

prompt_ldap_password() {
  echo "[sudo] password for $(whoami):"
  stty_orig=$(stty -g)
  stty -echo
  read -r ldap_password
  stty "$stty_orig"
}

export tmdb() {
  prompt_ldap_password

  manager_server=$(expect -c "$(
     cat <<- EOF
       log_user 0
       set timeout -1
       spawn ssh -t manager1.tugboat.qa "sudo docker service ps tugboat-mongo --filter='desired-state=running' --format='{{.Node}}'"
       match_max 100000
       expect {
         -ex "Are you sure you want to continue connecting (yes/no/\[fingerprint\])?" {
           send -- "yes\r"
           send -- "\r"
           exp_continue
         }
         "*?assword*" {
           send -- "${ldap_password}\r"
           send -- "\r"
           exp_continue
         }
         -re {(manager[0-9]\.tugboat\.qa)} {
           set output \$expect_out(1,string)
         }
       }
       expect eof
       log_user 1
       puts "\$output"
       lassign [wait] pid spawnid os_error_flag value
       exit \$value
EOF
  )")
  echo "SSHing to $manager_server..."
  ssh -t $manager_server 'sudo sh -c "docker exec -it \$(docker ps --filter \"name=\$(docker service ps tugboat-mongo --filter='desired-state=running' --format='{{.Name}}')\" -q) mongo"'
}
