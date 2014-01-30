#!/bin/bash


if [ ! -f "./happy.png" -o ! -f "./faint.png" -o ! -f "./scared.png" ]
then
    echo "Assets not found. Please make sure you are running ./configure from within walkins root directory."
fi

echo "Moving assets..."
mkdir -p ~/.walkins/assets
chmod 755 -R ~/.walkins
cp *.png ~/.walkins/assets/

echo "Creating the configuration file..."
touch ~/.walkins/.walkinsrc
cat default.conf > ~/.walkins/.walkinsrc
touch ~/.walkins/logfile
touch ~/.walkins/.credentials
read -p "Your Jenkins username please: " username
echo "Your Jenkins password please: "
read -s password
echo "$username:$password" > ~/.walkins/.credentials

read -p "The URL to the Jenkins view you want to track: " url
sed -i.bak "s,jenkins_url_here,$url,g" ~/.walkins/.walkinsrc

echo "Setting walkins up as a command..."
mkdir -p ~/local/bin
if [ -L ~/local/bin/walkins ]
then
    rm ~/local/bin/walkins
fi

ln -s ./walkins.sh ~/local/bin/walkins

touch ~/.walkins/.install-path
echo "INSTALL_PATH=$(pwd)" > ~/.walkins/.install-path

echo "Walkins configuration done! Fill out the ~/.walkins/.walkinsrc config file, run walkins command and enjoy the show!"
