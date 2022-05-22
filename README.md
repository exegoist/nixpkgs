## Deploy home environment using home-manager by nix

1. Install Nix Packages manager:

On linux:
```
sh <(curl -L https://nixos.org/nix/install) --daemon
```
On MacOS:
```
sh <(curl -L https://nixos.org/nix/install)
```
2. Install home-manager:
2.1. add and update channel:
```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```
2.2. add environment variable:
```
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
```
2.2. actually install home-manager:
```
nix-shell '<home-manager>' -A install
```
3. Restart (start new session) shell
4. Clone git repository and build config:
```
rm -rf .config/nixpkgs
git clone https://github.com/exegoist/nixpkgs.git .config/nixpkgs
home-manager build
home-manager switch
```
