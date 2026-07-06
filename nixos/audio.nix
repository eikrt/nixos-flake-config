{ pkgs, ... }: {

  # Musnix low-latency setup
  musnix = {
    enable = true;
    kernel.realtime = true; # <-- Change optimize to realtime
    kernel.packages = pkgs.linuxPackages_latest_rt;
    rtcqs.enable = true;
  };

  # Pipewire and Audio configurations
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
wireplumber.enable = true;
    
    # Global low-latency defaults for native JACK and ALSA clients
    # Note: PulseAudio specific latency settings (pulse.min.req) are deprecated 
    # in PipeWire 0.3.80+ and handled globally by default.clock.* parameters.
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;  # Fixed rate avoids resampling latency
        "default.clock.quantum" = 128;      # ~5ms latency at 48kHz
        "default.clock.min-quantum" = 32;   # Allows top-tier interfaces to achieve ~1.5ms
        "default.clock.max-quantum" = 512;
      };
    };

    # Disable node suspension to prevent audio pops on USB interfaces
    wireplumber.extraConfig."99-disable-suspend" = {
      "monitor.alsa.rules" = [{
        matches = [
          { "node.name" = "~alsa_input.*"; }
          { "node.name" = "~alsa_output.*"; }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        };
      }];
    };
  };

  # Real-time limits for the audio group
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile"; type = "-"; value = "99999"; }
  ];
}

