# ricks-scripts

### Ubuntu Bootstrap Quick Start
- Simply copy and paste this into terminal, enter your password for sudo and sit back and relax

```
sudo apt install git

BASHRC="$HOME/.bashrc"
ALIAS_NAME="bootstrap"
ALIAS_CMD='rm -rf "$HOME/Downloads/ricks-scripts" && git clone https://github.com/rocketpowerinc/ricks-scripts.git "$HOME/Downloads/ricks-scripts" && bash "$HOME/Downloads/ricks-scripts/ubuntu-bootstrap.sh"'

# Check if alias already exists
if grep -q "^alias ${ALIAS_NAME}=" "$BASHRC"; then
  echo "✔ Alias '${ALIAS_NAME}' already exists in ~/.bashrc"
  exit 0
fi

echo "➕ Adding '${ALIAS_NAME}' alias to ~/.bashrc"

{
  echo
  echo "# Bootstrap installer alias"
  echo "alias ${ALIAS_NAME}='${ALIAS_CMD}'"
} >> "$BASHRC"

source ~/.bashrc
```