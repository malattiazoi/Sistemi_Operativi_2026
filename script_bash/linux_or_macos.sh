if [ $(uname) = "Linux" ]; then
    echo "This is a Linux system."
    stat .
else
    echo "This is a MacOS system."
    stat -x .
fi

#whe use different stat command options based on the operating system,
#on macOS we use -x while on Linux we use the default options.