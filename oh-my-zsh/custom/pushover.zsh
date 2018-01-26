function push {
  HOSTNAME=`hostname | sed -e 's/\.local//'`
  curl -s -F "token=aRMVpKtCozKa3bhvBedXg3L8KXVsMk" \
    -F "user=uRHxRgrYAx6k2vyGf2qjgxbKqL7E8u" \
    -F "title=$HOSTNAME" \
    -F "message=$1" https://api.pushover.net/1/messages.json
}
