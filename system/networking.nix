{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    firewall.allowedTCPPorts = [
      8384
      22000
    ];
    firewall.allowedUDPPorts = [
      22000
      21027
    ];
  };
}
