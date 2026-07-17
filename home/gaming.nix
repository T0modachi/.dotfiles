{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vulkan-tools
    dxvk
    mesa
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    libva
    libva-utils
    protonup-qt
    wine
  ];
}
