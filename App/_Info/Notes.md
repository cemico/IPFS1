
[IPFS]

[following steps from: https://ipfs.io/docs/getting-started/]

1. download Darwin /  amd64: https://dist.ipfs.io/#go-ipfs, extract
Daves-iMac-Desk:~ daverogers$ cd go-ipfs/

2. run ./install-sh
Daves-iMac-Desk:go-ipfs daverogers$ ./install.sh

3. sanity test
Daves-iMac-Desk:go-ipfs daverogers$ ipfs help

4. init
Daves-iMac-Desk:go-ipfs daverogers$ ipfs init
initializing IPFS node at /Users/daverogers/.ipfs
generating 2048-bit RSA keypair...done
peer identity: QmY3FkrKCLHZoL9w4eLuq1KAGCH5K8d6UCZyhWFBQBQES7
to get started, enter:

ipfs cat /ipfs/QmS4ustL54uo8FzR9455qaxZwuMiUhyvMcX9Ba8nUH4uVv/readme

5. sanity test (use hash returned from init)
Daves-iMac-Desk:go-ipfs daverogers$ ipfs cat /ipfs/QmS4ustL54uo8FzR9455qaxZwuMiUhyvMcX9Ba8nUH4uVv/readme

6. quick start commands
Daves-iMac-Desk:go-ipfs daverogers$ ipfs cat /ipfs/QmS4ustL54uo8FzR9455qaxZwuMiUhyvMcX9Ba8nUH4uVv/quick-start

if you plan on being a node, setup the daemon and shared folders (file and name):
7. start daemon in another terminal
Daves-iMac-Desk:go-ipfs daverogers$ ipfs daemon
Initializing daemon...
Adjusting current ulimit to 2048...
Successfully raised file descriptor limit to 2048.
Swarm listening on /ip4/10.0.1.36/tcp/4001
Swarm listening on /ip4/127.0.0.1/tcp/4001
Swarm listening on /ip6/::1/tcp/4001
Swarm listening on /p2p-circuit/ipfs/QmY3FkrKCLHZoL9w4eLuq1KAGCH5K8d6UCZyhWFBQBQES7
Swarm announcing /ip4/10.0.1.36/tcp/4001
Swarm announcing /ip4/127.0.0.1/tcp/4001
Swarm announcing /ip4/67.159.151.70/tcp/18117
Swarm announcing /ip6/::1/tcp/4001
API server listening on /ip4/127.0.0.1/tcp/5001
Gateway (readonly) server listening on /ip4/127.0.0.1/tcp/8080
Daemon is ready

8. sanity check - see swarm peer addresses (truncated)
Daves-iMac-Desk:go-ipfs daverogers$ ipfs swarm peers
/ip4/103.234.143.151/tcp/4001/ipfs/QmPa5t3WTtrvZnqCebymNWKW2Mz3kzoyHY6nQifxq25839
/ip4/104.131.131.82/tcp/4001/ipfs/QmaCpDMGvV2BGHeYERUEnRQAwe3N8SzbUtfsmvsqQLuvuJ
/ip4/104.163.152.148/tcp/63873/ipfs/QmRpBxpEu7dzphKscPZKopKGRwEWKtwWEGVhoEM3VFBRG9

9. sanity download of content, sample cat file:
Daves-iMac-Desk:go-ipfs daverogers$ ipfs cat /ipfs/QmW2WQi7j6c7UgJTarActp7tDNikE4B2qXtFCfLPdsgaTQ/cat.jpg >cat.jpg
Daves-iMac-Desk:go-ipfs daverogers$ open cat.jpg

10. curl works fine, but I prefer the web console: http://localhost:5001/webui
This should bring up your node info, peer ID matching that returned above in the ipfs init call, along with the same network addresses

note: all terminal commands are available via http, for example (see https://ipfs.io/docs/api/):

> ipfs swarm peers
is equivalent to: http://127.0.0.1:5001/api/v0/swarm/peers
is equivalent to: > curl http://127.0.0.1:5001/api/v0/swarm/peers

See who you're directly connected to:
ipfs swarm peers
Manually connect to a specific peer. If the peer below doesn't work, choose one from the output of ipfs swarm peers.
ipfs swarm connect /ip4/104.236.176.52/tcp/4001/ipfs/QmSoLnSGccFuZQJzRadHn95W2CrSFmZuTdDWP8HXaHca9z
Search for a given peer on the network:
ipfs dht findpeer QmSoLnSGccFuZQJzRadHn95W2CrSFmZuTdDWP8HXaHca9z

11. setup mount points
a) sudo mkdir /ipfs /ipns
b) sudo chown `whoami` /ipfs /ipns
c) [optionally] restart daemon: ipfs daemon --mount

12. public either by giving hash or if you sign the data, give the public key

13. pin command keeps the file alive over 24 hours.  to view pin’d files, as shown on dashboard:
Daves-iMac-Desk:~ daverogers$ i pin ls | grep -i recursive

14. nice encryption ipfs article: https://medium.com/@mycoralhealth/learn-to-securely-share-files-on-the-blockchain-with-ipfs-219ee47df54c


[SERVER ipfs components setup]

1. update node pieces
a) sudo npm cache clean -f
b) sudo npm install -g n
c) sudo n stable

2. install ipfs node pieces
a) npm install ipfs
b) npm install async

3. validate can add via node
a) download https://github.com/ipfs/js-ipfs/blob/master/examples/ipfs-101/1.js (note: nice article as well)
b) run, validate returned key against ipfs gateway, mine: https://ipfs.io/ipfs/QmXgZAUWd8yo4tvjBETqzUy3wLx5YRzuDwUQnBwRGrAmAo


[SERVER node components setup]
1. mongo
a) download: http://www.mongodb.org/downloads OR npm install mongodb
b) add the Mongo 'bin' folder to your path (eg. Update .bash_profile)
c) run 'mongod' on port 27017 (the default port)
d) sanity check, launch shell, mongo, type "db" to show current database in use within shell, "show dbs", "use <db>", etc.
e) quick reference: https://docs.mongodb.com/manual/reference/mongo-shell/

2. node
a) https://nodejs.org/en/download/

3. basic node server with supporting modules
a) body-parser: npm install body-parser --save
b) express:     npm install express --save
c) mondodb:     npm install mongodb --save
d) mongoose:    npm install mongoose --save
e) gulp:        npm rm --global gulp
f) gulp:        npm install --global gulp-cli
g) package:     npm init
h) gulp:        npm install --save-dev gulp

4. auto gen basic app, express-generator
a) sudo npm install express-generator -g
b) express <app> -e
c) cd <app>
d) npm install
e) npm start

5. start
a) from server folder where App.js resides, run: node App.js
