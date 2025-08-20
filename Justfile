# Show a list of recipes
default:
    @just --list

# Checks syntax of all nix files
check:
  find . -name '*.nix' | xargs nix-instantiate --parse > /dev/null

# Runs nix lint
lint:
  nix run github:nix-community/nixpkgs-lint -- ./upwind-sensor

# Runs unit tests
test:
  nix eval --impure --expr 'import ./upwind-sensor/test/test.nix {}'
