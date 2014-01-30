#!/bin/bash


if [ ! -f "./happy.png" -o ! -f "./faint.png" -o ! -f "./scared.png" ]
then
    echo "Assets not found. Please make sure you are running ./configure from within walkins root directory."
fi

mkdir -p ~/.walkins/assets
mkdir -p ~/local/bin
chmod 755 -R ~/.walkins
cp *.png ~/.walkins/assets/

touch ~/.walkins/.walkinsrc
cat default.conf > ~/.walkins/.walkinsrc
if [ -L ~/local/bin/walkins ]
then
    echo "Updating symlink to walkins..."

    rm ~/local/bin/walkins
fi

ln -s ./walkins.sh ~/local/bin/walkins

touch ~/.walkins/logfile
touch ~/.walkins/.credentials
echo "username:password" > ~/.walkins/.credentials

touch ~/.walkins/.install-path
echo "$(pwd)" > ~/.walkins/install-path

echo "Walkins configuration done! Fill out the ~/.walkins/.walkinsrc config file, run walkins command and enjoy the show!"
