# System Manager Demo: Hello Node

This is a sample Docker container (that runs a very basic Express.js node app) that functions as a systemd service. It's registered using our Nix system-manager app.

## First build the Docker image

The Dockerfile contains everything you need to bulid the image; it runs npm install for you. To build the image, simply run:

```
docker build -t hello-node
```

Tip: Although we could add to our .nix files the work of building the docker image, we chose not to because we wanted to isolate our examples and focus only on registering the service.

## Now register it as a system service

System-manager takes care of everything, and we've included two .nix files to do the work for you. From the root folder, drop into a root shell and simply run:

```
sudo bash
nix run 'github:numtide/system-manager' -- switch --flake '.'
```

and your system should get registered with systemd and launched. If successful, point your browser to:

```
http://localhost:3000
```

and you should see "Hello, Node!"

# The Two .nix Files

There are two .nix files:

* **flake.nix** in the root
* **default.nix** in the Modules folder

The first one is configured to make use of system-manager with the following lines:

```
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
```

It also registers the modules folder:

```
  outputs = { self, flake-utils, nixpkgs, system-manager }: {
    systemConfigs.default = system-manager.lib.makeSystemConfig {
      modules = [
        ./modules
      ];
    };
  };
```

Inside the modules folder is the default.nix file, which contains the configuration information necessary for systemd:

```
    systemd.services = {
      hello-node = {
        enable = true;
        description = "Hello node.js docker container";
        after = [ "network.target" "docker.service" ];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          ExecStart = "/usr/bin/docker run --name hello-node-container -p 3000:3000 hello-node:latest";
          ExecStop = "/usr/bin/docker stop hello-node-container";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
```

