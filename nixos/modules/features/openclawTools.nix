{ ... }:
{
  flake.nixosModules.openclawTools =
    { self, pkgs, ... }:
    {
      environment.systemPackages =
        with pkgs;
        with self.packages.${pkgs.stdenv.hostPlatform.system};
        [
          blogwatcher
          clawhub
          ffmpeg
          gifgrep
          mcporter
          openai-whisper
          spotify-player
          summarize
          tmux
          wacli
          xurl
        ];
    };

  perSystem =
    { pkgs, ... }:
    let
      blogwatcherVersion = "0.0.3";

      gifgrepBinary = pkgs.stdenvNoCC.mkDerivation {
        pname = "gifgrep";
        version = "0.3.0";

        src =
          if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then
            pkgs.fetchurl {
              url = "https://github.com/steipete/gifgrep/releases/download/v0.3.0/gifgrep_0.3.0_linux_amd64.tar.gz";
              hash = "sha256-1GEH+3RRDj5TIqK4y2714nM4YAC7Uo3JuaQXG/JlJRE=";
            }
          else if pkgs.stdenv.hostPlatform.system == "aarch64-linux" then
            pkgs.fetchurl {
              url = "https://github.com/steipete/gifgrep/releases/download/v0.3.0/gifgrep_0.3.0_linux_arm64.tar.gz";
              hash = "sha256-2YQDPikHTDi23AgkSTqgMxtZbYGrqsgENMaaesxQ6Qk=";
            }
          else
            throw "gifgrep is only packaged for Linux in this configuration";

        sourceRoot = ".";

        installPhase = ''
          runHook preInstall

          install -Dm755 gifgrep "$out/bin/gifgrep"

          runHook postInstall
        '';
      };

      summarizeVersion = "0.20.1";

      xurlBinary = pkgs.stdenvNoCC.mkDerivation {
        pname = "xurl";
        version = "1.0.3";

        src = pkgs.fetchurl {
          url = "https://github.com/xdevplatform/xurl/releases/download/v1.0.3/xurl_Linux_x86_64.tar.gz";
          hash = "sha256-NLxnv7rymuEh93iPvSSR06i5XLOUczOtOXMuaUSXwYI=";
        };

        sourceRoot = ".";

        installPhase = ''
          runHook preInstall

          install -Dm755 xurl "$out/bin/xurl"

          runHook postInstall
        '';
      };
    in
    {
      packages = {
        blogwatcher = pkgs.buildGoModule {
          pname = "blogwatcher";
          version = blogwatcherVersion;

          src = pkgs.fetchFromGitHub {
            owner = "Hyaxia";
            repo = "blogwatcher";
            rev = "v${blogwatcherVersion}";
            hash = "sha256-Zd3Pqv2gCB6EwSR5uh88aHEXtI49mmXSbKuVDf2vAGA=";
          };

          subPackages = [ "cmd/blogwatcher" ];
          vendorHash = "sha256-TfcMKlr/mdElYLf2zw9iNLJgGVJzMVg97jJm015ClTQ=";
        };

        clawhub = pkgs.buildNpmPackage {
          pname = "clawhub";
          version = "0.23.0";

          src = ../../pkgs/clawhub;

          npmDepsHash = "sha256-urQt+gYtWxg93TVHj6357vFqmNQLIMiySDUW7edjhBE=";
          dontNpmBuild = true;
        };

        gifgrep = gifgrepBinary;

        summarize =
          let
            pnpm = pkgs.pnpm_10 or pkgs.pnpm;
            src = pkgs.fetchFromGitHub {
              owner = "steipete";
              repo = "summarize";
              rev = "v${summarizeVersion}";
              hash = "sha256-HaL3/AnWB5EDd91gJh2HPlUiRMQc077tBnRkbvIi0Zw=";
            };
          in
          pkgs.buildNpmPackage rec {
            pname = "summarize";
            version = summarizeVersion;

            inherit src;

            nativeBuildInputs = [ pnpm ];
            npmConfigHook = pkgs.pnpmConfigHook;
            dontNpmPrune = true;
            postInstall = ''
              cp -R packages "$out/lib/node_modules/@steipete/summarize/"
              rm -f "$out/lib/node_modules/@steipete/summarize/node_modules/.pnpm/node_modules/@steipete/summarize-chrome-extension"
            '';
            npmDeps = pnpmDeps;
            pnpmDeps = pkgs.fetchPnpmDeps {
              pname = "summarize";
              version = summarizeVersion;
              inherit src;
              inherit pnpm;
              fetcherVersion = 3;
              hash = "sha256-cUzTtxCzHtHoaLmxzeOeo2FJaqRCOxeLiKEbGXbP/oQ=";
            };
          };

        wacli = pkgs.buildGoModule {
          pname = "wacli";
          version = "0.11.1";

          src = pkgs.fetchFromGitHub {
            owner = "steipete";
            repo = "wacli";
            rev = "v0.11.1";
            hash = "sha256-YeJzL/m38sUpoln3uBUH95wWC1sC60W0wPDrGJuvd3M=";
          };

          subPackages = [ "cmd/wacli" ];
          vendorHash = "sha256-N5VIGCfMuaMbSuxwQLXUOCBGJ23WM4+3UA6vZhvxOPs=";
        };

        xurl =
          if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then
            xurlBinary
          else
            throw "xurl is only packaged for x86_64-linux in this configuration";
      };
    };
}
