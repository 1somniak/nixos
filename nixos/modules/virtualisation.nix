{ pkgs, ... }:

{
  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Virtual machine management
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["louis"];
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.runAsRoot = true;
  networking.firewall.trustedInterfaces = ["virbr0"];
  systemd.services.libvirt-default-network = {
    description = "Start libvirt default network";
    after = ["libvirtd.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
      ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
      User = "root";
    };
  };
}
