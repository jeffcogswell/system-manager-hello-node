{ config, lib, pkgs, ... }:

{
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";
    system-manager.allowAnyDistro = true;

    environment = {
    };

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
  };
}