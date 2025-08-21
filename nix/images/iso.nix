# images/iso.nix
{
  lib,
  ...
}:
##   - Build iso:
# nix build .#iso
##   - Find installation device (eg. /dev/sdX):
# lsblk
##   - Write to thumb-drive:
# sudo dd bs=4M if=result/iso/my-nixos-live.iso of=/dev/sdX status=progress oflag=sync
{
  imports = [
    ./base-config.nix
  ];

  isoImage.volumeID = lib.mkForce "nixos-live";
  image.fileName = lib.mkForce "nixos-live.iso";
  # Use zstd instead of xz for compressing the liveUSB image, it's 6x faster and 15% bigger.
  isoImage.squashfsCompression = "zstd -Xcompression-level 6";
}
