# Rubber Rats server config

Nixos config for the server


Rebuild the server with this command while logged in via ssh:

```sh
sudo nixos-rebuild swtich
```



cd /root/RubberRats-ServerConfigs

nix-shell -p git

git pull

sudo nixos-rebuild switch --flake . 
