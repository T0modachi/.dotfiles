{
  users.users.T0modachi = {
    isNormalUser = true;
    description = "T0modachi";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;
}
