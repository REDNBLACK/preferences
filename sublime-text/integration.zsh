# Create symlink if not set or broken
if [[ ! -L /usr/local/bin/subl || ! -e /usr/local/bin/subl ]]; then
    ln -fs "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
fi

# Set as default editor
export EDITOR='subl -w'