# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixpkgs/nixos/modules/profiles/base.nix>
      <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    ];

  nixpkgs.config.allowUnfree = true;

  # Use the GRUB 2 boot loader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.systemd-boot.enable = true;
  #boot.kernelParams = [ 
  #  # Power saving features from the Arch Linux Wiki for Dell XPS 15 9560
  #  "acpi_rev_override=1"
  #];

  networking.hostName = "scalpel"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.wireless.networks = {
  #  "Pretty Fly for a Wi-Fi" = { psk = "idontknow"; };
  #};

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim firefox-devedition-bin-unwrapped xorg.xmodmap rcm 
    xorg.xcursorthemes
    # telegram
    tdesktop
    git
    htop
    appimage-run  # to run jetbrains toolbox which is an AppImage
    powerline-fonts

    # redshift for dimming the screen and turning it yellow at night
    redshift geoclue2

    networkmanagerapplet
    pa_applet

    light  # managed backlight
  ];

  services.udev.packages = [ pkgs.light ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };
  users.users.ba = {
    isNormalUser = true;
    home = "/home/ba";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
  };

  security.sudo.extraRules = [
    { groups = [ "wheel" ]; commands = [ "ALL" ]; }
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

  i18n.consoleFont = "latarcyrheb-sun32";

  services.xserver = {
    enable = true;
    autorun = true;
    libinput.enable = true;
    
    videoDrivers = [ "modesetting" ]; #"intel" "nvidia" ];

    displayManager.lightdm.enable = true;
    desktopManager.gnome3.enable  = true;
    windowManager.i3.enable = true;
    monitorSection = ''
      DisplaySize 406 228
    '';
  };
  hardware.bumblebee = {
    enable = true;
    pmMethod = "none";
  };
  hardware.nvidia = {
    modesetting = { enable = true; };
  
    optimus_prime = {
      enable = true;
      # values from lspci, lspci | grep -P 'VGA|3D'
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  #hardware.bumblebee.enable = true;
  #hardware.bumblebee.connectDisplay = true;
  #hardware.bumblebee.pmMethod = "bbswitch";
  fonts = {
    fonts = with pkgs; [
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif     = [ "Source Serif Pro" ];
      };

      ultimate = { enable = true; };
    };
  };

  # powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.powertop.enable = true;

}
