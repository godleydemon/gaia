# Gaia
Gaia is a provisioning system for new linux servers running on debian or debian derivitives. It prepares a server for Minecraft servers: installing java, setting up ssh key only login, installing various apts, as well as securing ssh. 

> Please be aware, you will need to put in a SSH key into the
> ~/.ssh/authorized_keys file. If there isn't one there, create one.

Gaia also serves as a tool for creating Minecraft servers securely with little to no experience with server backends. It creates a new user account for each server that you create, copies over the ssh keys that are in `~/.ssh/authorized_keys` and moves the master server.properties file that has the port stripped out into the new user home directory. It will then grab the port from a user provided port; that the user provided during Gaia's initial questions. Then it will put that port into the server.properties file.

You will then be presented with a choice of jars to install into the new user home directory, this list is pulled from a Master serverjars directory. When selecting a serverjar, it's asking for the full name, .jar and all. Once that's done, it'll then dynamically create the start.sh file for the rest of the information you have provided. At the end, it Chown everything to the new user account.

In order to launch the server, please log into the newly created user account and launch it within something like a screen session. 

    Example: screen -S $servername 
    ./start.sh

the start.sh file will auto restart once the server stops, so it's up to you to actually ctrl + c it if you want to shut it down.

The server port is not automatically opened, as that's something you should do when your ready. 

    example: ufw allow $portnumber
