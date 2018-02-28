source ~/private/.pushover
function push {
  HOSTNAME=`hostname | sed -e 's/\.local//'`
  curl -s -F "token=$PUSHOVER_TOKEN" \
    -F "user=$PUSHOVER_USER" \
    -F "title=$HOSTNAME" \
    -F "message=$1" https://api.pushover.net/1/messages.json
}
