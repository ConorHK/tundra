{ ... }:
{
  imports = [
    ./fail2ban
    ./spotifyd
    ./sshd
    ./tts-web.nix
    ./uptime-kuma
  ];
}
