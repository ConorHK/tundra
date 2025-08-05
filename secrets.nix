let
  remote-dev-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM1dqJ15DRGT+4lm/hc/Bc9zm6HLOXcEGOVQ3gaEgcJM";
  users = [ remote-dev-user ];
in
{
  "nix/hosts/secrets/ntfy.age".publicKeys = [ remote-dev-user ];
}
