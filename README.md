Unofficial adventure.land docker setup.

This set up two docker containers using the official repositories : https://github.com/kaansoral/adventureland, https://github.com/kaansoral/adventureland-appserver.

The containers are connected to the host network so listening ports are automatically opened to your LAN.

The docker compose maps the directory /alserver/ on the docker host into the continers at /alserver/ and this is where everything is stored.

When the containers first launch, they check to see if the /alserver/adventureland and /alserver/adventureland/appserver directories exist and if not the repositories are cloned, required settings files are copied and files are modified to allow outside (LAN) access.

Currently, the adventureland/js/game.js file is modified to replace the address 0.0.0.0 with an internal ip - this will hopefully be improved to auto detect or pass your own IP but for now you should edit the server_entrypoint.sh file and change the IP in there to your servers address before starting the stack.

The default ports are :  HTTP 80 for the game client, HTTP 8081 for the GAE Admin.
 The node server listens on 8022 and the API port is random this is one reason the network mode is host so the API port is made available automatically to the other docker container).

THIS IS A WORK IN PROGRESS!

To run on Proxmox Docker/Portainer LXC (DRAFT):
 Create the Proxmox LXC if you do not have one already:
  - from the proxmox shell, run: `bash -c "$(wget -qLO - https://raw.githubusercontent.com/community-scripts/ProxmoxVE/refs/heads/main/ct/docker.sh)"`
  - use advanced settings, debian , 12 , PRIVILEGED , 100 GB disk (or whichever size you prefer) , 6 cores, 16 GB RAM, optionally install portainer for the nice web interface)
  - once the lxc is started, if you are using portainer you can simply create a new stack, repository, give it a name and paste in the repository address and deploy: https://github.com/SSzretter/adventurelanddocker
  - OPTIONAL: if you are not using portainer, you can use the shell and run: `apt-get install git`
   - ` git clone https://github.com/SSzretter/adventurelanddocker `
   - ` cd adventurelanddocker `
   - You can run ` docker compose up ` to start the containers and the stack should also appear in portainer


Once the containers are running you should be able to access your adventure.land by opening a browser and going to ` http://yourdockerhostip `
 For Proxmox Portainer LXC the IP address of the LXC host on your LAN (recommend creating an IP reservation or give the LXC a static IP).
The adventure.land game should start and you should be able to click 'Sign up (development use)' to register your account.   Email verification is not required.
Once you sign up the list of characters will appear and you can create a new character in a slot.

TROUBLESHOOTING / FAQ : 
 - if the game loads but the background map is not drawing, click in the URL bar and press F12 and look for console messages indicating the web socket connection is failing - usually its trying to connect to "0.0.0.0" in that case.   Currently that means the adventureland/js/game.js file needs to be modified where it sets 'server_addr="0.0.0.0"' by default (the docker script attempts to set this using sed and you may need to adjust the script and/or the .js file).

FUTURE:
 How to become ADMIN
 Useful ADMIN commands

 How to view data (gae , db files)

 settings files?

 Windows Docker (install docker, ...)
 Standard Linux VM's/machines/LXC  (install docker first)

 POSSIBLE FUTURE - cloudflared access
 
