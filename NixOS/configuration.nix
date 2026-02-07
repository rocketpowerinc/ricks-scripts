# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


####################      APPS    ############################
##############################################################
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl 
    wget
    yad
    git
    just
    dconf-editor
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.dash-to-dock
    gnomeExtensions.accent-gtk-theme
    gnomeExtensions.accent-icons-theme
    gnomeExtensions.arcmenu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.lock-keys
    gnomeExtensions.media-controls
    gnomeExtensions.network-stats
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.simpleweather
    gnomeExtensions.tiling-assistant
    gnomeExtensions.user-themes
    gnomeExtensions.appindicator
    gnomeExtensions.burn-my-windows
    gnomeExtensions.compiz-windows-effect
  ];
################################################################
################################################################

  
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # VM Bootloader
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/sda";


  # Networking
  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  ##############################################################
  ################### GNOME DARK MODE ##########################
  ##############################################################
  programs.dconf.enable = true;

  services.desktopManager.gnome.extraGSettingsOverrides = ''
  [org.gnome.desktop.interface]
  color-scheme='prefer-dark'
  gtk-theme='Adwaita-dark'
  icon-theme='Adwaita'
  '';


  ##############################################################
  ##############################################################


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rick = {
    isNormalUser = true;
    description = "rick";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "password";
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "rick";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

##############################################################
################### ⭐ NIX-FLATPAK CONFIG ####################
##############################################################
  # This works AFTER you add nix-flatpak to flake.nix modules
  services.flatpak = {
    enable = true;

    ### ⭐ ADDED example flatpaks (edit as you want)
    packages = [
      "org.gnome.Boxes"
      "io.github.alescdb.mailviewer"
      "dev.fredol.open-tv"
      "org.gnome.gThumb"
      "com.rtosta.zapzap"
      "io.ente.photos"
      "com.github.jeromerobert.pdfarranger"
      "com.github.qarmin.czkawka"
      "net.fhannenheim.musicfetch"
      "de.haeckerfelix.Shortwave"
      "org.gnome.Brasero"
      "com.github.neithern.g4music"
      "io.gitlab.adhami3310.Impression"
      "org.kde.haruna"
      "org.libreoffice.LibreOffice"
      "com.mattjakeman.ExtensionManager"
      "org.gramps_project.Gramps"
    ];

    ### ⭐ ADDED (auto update flatpaks weekly)
    update.auto.enable = true;
    update.auto.onCalendar = "weekly";
  };
##############################################################
##############################################################


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  system.stateVersion = "25.05"; # Did you read the comment?

}