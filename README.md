There are two components in this project, both of which are supposed to be built using dune separately on two different devices.
In order to test the project, open a terminal window and from the root of the repo, type:

```
cd server
dune exec -- ./server.exe -port 225

```

On another terminal window, type the following:

```
cd client
dune exec -- ./client.exe -port 225 -ip 127.0.0.1

```

Sending `exit` from the client side terminates the current client. An instance of the chat is given below

### The Server Side
```
aimanimtiaz@Aimans-MBP ocaml-chat % cd server
aimanimtiaz@Aimans-MBP server % dune exec -- ./server.exe -port 225
Client: hi           
hello
Message Received
Roundtrip time: 0.000491s

Client: what's up
nothing
Message Received
Roundtrip time: 0.000431s

Client: ok then i will leave
ok
Message Received
Roundtrip time: 0.000449s

```

### The Client Side

```
aimanimtiaz@Aimans-MBP ocaml-chat % cd client
aimanimtiaz@Aimans-MBP client % dune exec -- ./client.exe -port 225 -ip 127.0.0.1
hi                   
Message Received
Roundtrip time: 0.000735s

Server: hello
what's up
Message Received
Roundtrip time: 0.003861s

Server: nothing
ok then i will leave
Message Received
Roundtrip time: 0.000507s

Server: ok
exit
aimanimtiaz@Aimans-MBP client % 

```
