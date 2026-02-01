# ricks-scripts

### Ubuntu Bootstrap Quick Start
1. Copy and paste the code block below into a terminal and press enter. The terminal window will close.
2. Then simply open another terminal window and enter the command `bootstrap` and press enter

```
sudo apt install git -y

BASHRC="$HOME/.bashrc"
ALIAS_NAME="bootstrap"
ALIAS_CMD='rm -rf "$HOME/Downloads/ricks-scripts" && git clone https://github.com/rocketpowerinc/ricks-scripts.git "$HOME/Downloads/ricks-scripts" && bash "$HOME/Downloads/ricks-scripts/ubuntu-bootstrap.sh"'

# Check if alias already exists
if grep -q "^alias ${ALIAS_NAME}=" "$BASHRC"; then
  echo "✔ Alias '${ALIAS_NAME}' already exists in ~/.bashrc"
  exit 0
fi

echo -e "\033[1;32m➕ Adding '${ALIAS_NAME}' alias to ~/.bashrc\033[0m"


{
  echo
  echo "# Bootstrap installer alias"
  echo "alias ${ALIAS_NAME}='${ALIAS_CMD}'"
} >> "$BASHRC"

sleep 3 && exit
```