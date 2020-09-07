if [ -x "$(command -v multipass)" > /dev/null 2>&1 ]; then
    # Linux/MacOS
    MULTIPASSCMD="multipass"
else
    echo "The multipass binary (multipass or multipass.exe) is not available or not in your \$PATH"
    exit 1
fi

if [ -x "$(command -v kubectl)" > /dev/null 2>&1 ]; then
    # Linux/MacOS
    KUBECTLCMD="kubectl"
else
    echo "The kubectl binary is not available or not in your \$PATH"
    exit 1
fi

FILE=~/.ssh/id_rsa.pub
if [ ! -r "$FILE" ]; then
    echo "No SSH key given, in path: ${FILE}"
fi
