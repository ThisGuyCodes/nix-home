{ pkgs, lib, inputs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # pkgs.ghostty
  ];

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  homebrew = {
    enable = true;
    global = { autoUpdate = true; };
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    brews = [ "withgraphite/tap/graphite" ];
    taps = [ "withgraphite/tap" ];
    casks = [
      "secretive"
      "discord"
      "google-chrome"
      "ghostty"
      "signal"
      "zed"
      "todoist"
      "rectangle-pro"
      # "podman-desktop"
      "1password-cli"
    ];
  };

  environment.shells = [ pkgs.zsh ];

  system.keyboard = { remapCapsLockToEscape = true; };

  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      FXRemoveOldTrashItems = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };

    menuExtraClock = {
      Show24Hour = true;
      ShowDate = 2;
      ShowDayOfWeek = true;
    };

    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 5;
    };

    dock = {
      autohide = true;
      persistent-apps = [ ];
      persistent-others = [ ];
      showhidden = true;
      tilesize = 32;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

    NSGlobalDomain = {
      AppleInterfaceStyleSwitchesAutomatically = true;
      AppleShowAllFiles = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      AppleICUForce24HourTime = true;
    };
  };

  users.users.thisguy = {
    home = "/Users/thisguy";
    shell = pkgs.zsh;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision =
    inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
