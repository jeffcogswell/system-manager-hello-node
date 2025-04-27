# System Manager Demo: Hello Node

This is a sample Docker container (that runs a very basic Express.js node app) that functions as a systemd service. It's registered using our Nix system-manager app.

## First build the Docker image

The Dockerfile contains everything you need to bulid the image; it runs npm install for you. To build the image, simply run:

```
docker build -t hello-node
```

## Now register it as a system service

System-manager takes care of everything, and we've included two .nix files to do the work for you. From the root, simply run:

```
nix run 'github:numtide/system-manager' -- switch --flake '.'
```

and your system should get registered with systemd and launched. If successful, point your browser to:

```
http://localhost:3000
```

and you should see "Hello, Node!"

