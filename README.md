To init on a new computer:

```
bash -c "$(curl -fsSL https://github.com/q0rban/homedir/raw/main/init.sh\?$(date +'%s'))"
```

To re-export your Brewfile.

```
brew bundle dump --file ~/Workspace/homedir/Brewfile -f
```
