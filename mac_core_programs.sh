BREWINSTALLED=$(which brew 2>&1)

if [[ "$BREWINSTALLED" == "" ]]; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing golang"
brew install golang

echo "Installing node"
brew install node

echo "Install yarn"
brew install yarn

echo "Installing git-fixit"
npm install -g git-fixit
