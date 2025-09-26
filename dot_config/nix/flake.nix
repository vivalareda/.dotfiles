{
  description = "The best system config ever known to man kind";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
    let
      configuration = { pkgs, ... }: {
        # Set the primary user (required for system defaults)
        system.primaryUser = "lilflare";
        nix.enable = false;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility. please read the changelog
        # before changing: `darwin-rebuild changelog`.
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Declare the user that will be running `nix-darwin`.
        users.users.lilflare = {
          name = "lilflare";
          home = "/Users/lilflare";
        };

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;

        # System packages
        environment.systemPackages = with pkgs; [
          karabiner-elements
          iina
        ];

        # macOS system preferences
        system.defaults = {

          controlcenter = {

            # Enabled
            Bluetooth = true;
            Sound = true;

            # Disabled
            FocusModes = false;
            NowPlaying = false;
            BatteryShowPercentage = false;
          };

          CustomUserPreferences = {
            "com.apple.systemuiserver" = {
              menuExtras = [
                "/System/Library/CoreServices/Menu Extras/Volume.menu"
                "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"
                "/System/Library/CoreServices/Menu Extras/AirPort.menu"
                "/System/Library/CoreServices/Menu Extras/Clock.menu"
              ];
            };

            "com.apple.symbolichotkeys" = {
              AppleSymbolicHotKeys = {
                # Disable 'Cmd + Space' for Spotlight Search
                "64" = { enabled = false; };
                "60" = { enabled = false; };
                "61" = { enabled = false; };
                "65" = { enabled = false; };
              };
            };

            "com.apple.finder" = {
              _FXSortFoldersFirst = true;
              FXDefaultSearchScope = "SCcf";

              # Remove Recents from sidebar
              ShowRecentTags = false;

              # Remove Tags section
              SidebarTagsSctionDisclosedState = false;
            };
          };

          # Dock settings
          dock = {
            wvous-tl-corner = 1;  # Top left - disabled
            wvous-tr-corner = 1;  # Top right - disabled
            wvous-bl-corner = 1;  # Bottom left - disabled 
            wvous-br-corner = 1;  # Bottom right - disabled
            autohide = true;                # Auto-hide the dock
            show-recents = false;           # Don't show recent apps
            tilesize = 48;                  # Dock icon size
          };

          trackpad = {
            Clicking = true;
            FirstClickThreshold = 0;
            SecondClickThreshold = 0;
            ActuationStrength = 1;
          };

          # Finder settings
          finder = {
            AppleShowAllExtensions = true;  # Show file extensions
            ShowPathbar = true;             # Show path bar
            ShowStatusBar = true;           # Show status bar
            FXEnableExtensionChangeWarning = false; # No warning when changing extensions
            NewWindowTarget = "Documents";       # Documents folder
          };

          WindowManager = {
            EnableStandardClickToShowDesktop = false;
          };


          # Global system settings
          NSGlobalDomain = {

            "com.apple.mouse.tapBehavior" = 1;
            "com.apple.trackpad.forceClick" = false;

            # Appearance
            AppleInterfaceStyle = "Dark";   # Dark mode
            _HIHideMenuBar = true;          # Auto-hide menu bar

            # Window Management
            NSWindowShouldDragOnGesture = true;     # Cmd+Ctrl+click to move windows

            # Keyboard
            KeyRepeat = 2;                          # Fast key repeat
            InitialKeyRepeat = 15;                  # Short delay before repeat
            ApplePressAndHoldEnabled = false;       # Disable press-and-hold for accents

            # Time
            AppleICUForce24HourTime = false;        # Use 12-hour time

            # Interface
            AppleShowScrollBars = "Automatic";      # Show scrollbars when needed
            NSAutomaticWindowAnimationsEnabled = false; # Disable window animations
          };

          # Activity Monitor
          ActivityMonitor = {
            ShowCategory = 100;             # Show all processes
            SortColumn = "CPUUsage";        # Sort by CPU usage
            SortDirection = 0;              # Descending order
          };
        };

        # System keyboard shortcuts and other settings
        system.keyboard = {
          enableKeyMapping = true;
        };

        # Security settings - updated syntax
        security.pam.services.sudo_local.touchIdAuth = true; # Enable Touch ID for sudo
      };

    in
      {
      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
        ];
      };
    };
}
