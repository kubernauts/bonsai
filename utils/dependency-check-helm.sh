if [ -x "$(command -v helm)" > /dev/null 2>&1 ]; then
    # Linux/MacOS
    HELMCMD="helm"
else
    echo "The helm binary (helm or helm.exe) is not available or not in your \$PATH"
    exit 1
fi
