#!/bin/bash


if [ ! -f "./happy.png" -o ! -f "./faint.png" -o ! -f "./scared.png" ]
then
    echo "Assets not found. Please make sure you are running ./configure from within walkins root directory."
fi

echo "Moving assets..."
mkdir -p $HOME/.walkins/assets
chmod 755 -R $HOME/.walkins
cp *.png $HOME/.walkins/assets/

echo "Creating the configuration file..."
touch $HOME/.walkins/.walkinsrc
cat default.conf > $HOME/.walkins/.walkinsrc
touch $HOME/.walkins/logfile
touch $HOME/.walkins/.credentials
read -p "Your Jenkins username please: " username
echo "Your Jenkins password please: "
read -s password
echo "$username:$password" > $HOME/.walkins/.credentials

read -p "The URL to the Jenkins view you want to track: " url
sed -i.bak "s,jenkins_url_here,$url,g" $HOME/.walkins/.walkinsrc

echo "Setting walkins up as a command..."
mkdir -p $HOME/local/bin
if [ -L $HOME/local/bin/walkins ]
then
    rm $HOME/local/bin/walkins
fi

ln -s $(pwd)/walkins.sh $HOME/local/bin/walkins

chmod 770 $HOME/local/bin/walkins
touch $HOME/.walkins/.install-path
echo "INSTALL_PATH=$(pwd)" > $HOME/.walkins/.install-path

echo 'Walkins configuration done! Run the `walkins` command and enjoy the show!'
