#!/bin/bash
clear

echo "  *--==Gaia==--*"
echo "[1] Create MC Server"
echo "[2] Provision Server"
echo "[3] Install Spigot Buildtools"
echo "[4] Delete a Server"
echo "[5] Exit"
echo "  *--==||||==--*"

while true;do
  read -p "select operation : " selected
  case $selected in
    [1]*)
      clear
      if [ ! -d "/home/serverjars" ]; then
        echo "no serverjars directory in /home"
        while true;do
          read -p "Want me to make it for you? (y/n): " yn
          case $yn in
            [Yy]*)
              echo "Shitting on your home folder"
              mkdir /home/serverjars
              break ;;
            [Nn]*)
              echo "Fuck This Shit Im Out"
              exit 0 ;;
          esac
        done
      fi

      if [ ! -f ./server.properties ]; then
        echo "master server.properties file doesn't exist in root"
        while true;do
          read -p "Want me to get you one? (y/n): " yn
          case $yn in
            [Yy]*)
              echo "Grabbing it by the pussy"
              wget https://raw.githubusercontent.com/godleydemon/gaia/master/Master/server.properties
              break ;;
            [Nn]*)
              echo "Fuck This Shit Im Out"
              exit 0 ;;
          esac
        done
      fi
	  
      if [ ! -f ./spigot.yml ]; then
        echo "master spigot.yml file doesn't exist in root"
        while true;do
          read -p "Want me to get you one? (y/n): " yn
          case $yn in
            [Yy]*)
              echo "Grabbing it by the balls"
              wget https://raw.githubusercontent.com/godleydemon/gaia/master/Master/spigot.yml
              break ;;
            [Nn]*)
              echo "Fuck This Shit Im Out"
              exit 0 ;;
          esac
        done
      fi

      if [ ! -f ./.ssh/authorized_keys ]; then
        echo "we need an authorized key file to copy in /root/.ssh"
        exit 0
      fi

	  if [ ! -d "/usr/lib/jvm" ]; then
        echo "Java NOT installed! WTF!"
        echo "Installing Java8"
        apt-get install -y python-software-properties debconf-utils > /dev/null
		add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main"
        apt-get update > /dev/null
        echo "oracle-java8-installer  shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
        echo "oracle-java8-installer  shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
        apt-get install -y oracle-java8-installer 
        echo "Finished installing Java8"
	  fi

      read -p "Enter server name: " servername
      read -p "Enter port number: " portnumber
      read -p "Enter ram ammount: " ramammount
	  read -p "Is this connected to a bungee? [y/n]" bungeesupport

      echo "--==Server Jars==--"
      ls --format single-column /home/serverjars/
      echo "--===============--"
      read -p "type in a server jar: " jar

      echo "server name = $servername"
      echo "port number = $portnumber"
      echo "ram ammount = $ramammount"
      echo "server jar = $jar"
	  if [ $bungeesupport="y" ]; then
		echo "Bungee support = true"
	  else
		echo "Bungee support = false"
	  fi

      while true;do
        read -p "is this information correct? (y/n): " yn
        case $yn in
          [Yy]*)
            echo "Alright, Times up! LEEEROOOOOOYYYYYYYY JEEEEENNNNKKIIIIINNNSSSSS"
            continue=yes
            break ;;
          [Nn]*)
            echo "Fuck This Shit Im Out"
            exit 0 ;;
        esac
      done

      if [ $continue="yes" ]; then
        useradd -s /bin/bash -d /home/servers/$servername -m $servername
        mkdir /home/servers/$servername/.ssh
        cp ~/.ssh/authorized_keys /home/servers/$servername/.ssh/
        cp /home/serverjars/$jar /home/servers/$servername/
        cp /root/server.properties /home/servers/$servername/server.properties
        touch /home/servers/$servername/start.sh
        touch /home/servers/$servername/eula.txt
        echo "Creating start.sh file"
        echo "while true; do" >> /home/servers/$servername/start.sh
        echo "java -server -XX:MetaspaceSize=512M -XX:MaxGCPauseMillis=40 -Xmx"$ramammount"G -Xms"$ramammount"G -jar \"$jar\"" >> /home/servers/$servername/start.sh
        echo 'echo "server restarting in 5 seconds"' >>/home/servers/$servername/start.sh
        echo 'echo "to kill this do Ctrl+C"' >> /home/servers/$servername/start.sh
        echo 'sleep 5' >> /home/servers/$servername/start.sh
        echo "done" >> /home/servers/$servername/start.sh
        chmod +x /home/servers/$servername/start.sh
        echo "changing the port number"
        echo "server-port=$portnumber" >> /home/servers/$servername/server.properties
        echo "eula=true" >> /home/servers/$servername/eula.txt
		if [ $bungeesupport="y" ]; then
			echo "Changing server to offline mode because of Bungee support"
			echo -e "online-mode=false" >> /home/servers/$servername/server.properties
			cp /root/spigot.yml /home/servers/$servername/
			sed -i '/  bungeecord: false/c\  bungeecord: true' /home/servers/$servername/spigot.yml
		else
			echo ""
			cp /root/spigot.yml /home/servers/$servername/
			echo "online-mode=true" >> /home/servers/$servername/server.properties
		fi
        echo "changing ownership"
        chown -R $servername:$servername /home/servers/$servername
        echo "*--=shits done boss=--*"
        echo "make sure to log in via the new useraccount dipshit"
      else
        echo ">O<"
      fi
      echo "Alright, Times up! LEEEROOOOOOYYYYYYYY JEEEEENNNNKKIIIIINNNSSSSS"
      continue=yes
      exit 0 ;;
    [2]*)
      apt-get update > /dev/null
      echo "Installing a few packages, please wait"
      apt-get install -y software-properties-common screen tmux joe ssh git expect htop unzip make python-software-properties python-dev python-twisted-core python-twisted-web python-twisted-words libssl-dev python-pip software-properties-common gem ufw curl > /dev/null
      pip install urwid feedparser psutil > /dev/null
      gem install haste system_timer bundler > /dev/null
      git config --global core.editor "nano"
      echo "done installing packages"
	  if [ ! -d "/usr/lib/jvm" ]; then
        echo "Java NOT installed! WTF!"
        echo "Installing Java8"
        apt-get install -y python-software-properties debconf-utils > /dev/null
		add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main"
        apt-get update > /dev/null
        echo "oracle-java8-installer  shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
        echo "oracle-java8-installer  shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
        apt-get install -y oracle-java8-installer 
        echo "Finished installing Java8"
	  fi

      sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
      sed -i "s/#Banner \/etc\/issue.net/Banner\ \/etc\/issue.net/g" /etc/ssh/sshd_config
      sed -i "s/X11Forwarding yes/X11Forwarding no/g" /etc/ssh/sshd_config
      sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/g" /etc/ssh/sshd_config
	  mkdir ~/.ssh
	  touch ~/.ssh/authorized_keys
      service ssh restart
      echo "*--==Opening port 22 and enabling UFW firewall==--*"
      ufw allow 22
      ufw enable
	  echo "Login is now SSH keys only, please create an SSH key and put it into the authorized_keys file in ~/.ssh/authorized_keys"
	  echo "Do not log out yet, if you do, you will be locked out of your system!"
      echo "*--==done provisioning==--*"
      exit 0 ;;
    [3]*)
      echo "*--==Installing BuildTools==--*"
	  if [ ! -d "/usr/lib/jvm" ]; then
        echo "Java NOT installed! WTF!"
        echo "Installing Java8"
        apt-get install -y python-software-properties debconf-utils > /dev/null
		add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main"
        apt-get update > /dev/null
        echo "oracle-java8-installer  shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
        echo "oracle-java8-installer  shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
        apt-get install -y oracle-java8-installer > /dev/null
        echo "Finished installing Java8"
	  fi
	  mkdir /home/buildtools
	  wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O /home/buildtools/BuildTools.jar
	  git config --global --unset core.autocrlf
	  echo "Running buildtools Once, this will take a while"
	  cd /home/buildtools
	  java -jar /home/buildtools/BuildTools.jar
	  echo "Moving new Spigot jar to serverjars directory"
	  if [ ! -d "/home/serverjars" ]; then
		mkdir /home/serverjars
	  fi
	  mv /home/buildtools/spigot-*.jar /home/serverjars/
      exit 0 ;;
	[4]*)
      read -p "What is the server name we will be killing today?: " servername
        while true;do
          read -p "Warning this will destroy the server are you sure? [y/n]: " yn
          case $yn in
          [Yy]*)
            echo "Eating Ass"
            deluser --remove-home $servername
			echo "Jobs Done"
            break ;;
          [Nn]*)
            echo "Fuck This Shit Im Out"
            exit 0 ;;
          esac
        done
	  exit 0 ;;
    [5]*)
      echo "Fuck This Shit Im Out"
      exit 0 ;;
  esac
done
