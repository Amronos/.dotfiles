{ ... }:
{
  flake.nixosModules.openclawTools =
    { self, pkgs, ... }:
    {
      environment.systemPackages =
        with pkgs;
        with self.packages.${pkgs.stdenv.hostPlatform.system};
        [
          clawhub
          ffmpeg
          mcporter
          openai-whisper
          spotify-player
          tmux
          wacli
          xurl
        ];
    };

  perSystem =
    { pkgs, ... }:
    let
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
        clawhub = pkgs.buildNpmPackage {
          pname = "clawhub";
          version = "0.23.0";

          src = ../../pkgs/clawhub;

          npmDepsHash = "sha256-urQt+gYtWxg93TVHj6357vFqmNQLIMiySDUW7edjhBE=";
          dontNpmBuild = true;
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
