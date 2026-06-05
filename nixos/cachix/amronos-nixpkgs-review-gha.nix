
{
  nix = {
    settings = {
      substituters = [
        "https://amronos-nixpkgs-review-gha.cachix.org"
      ];
      trusted-public-keys = [
        "amronos-nixpkgs-review-gha.cachix.org-1:Bq46H/mVBR/pqwGYVb2QY54AS8HdiLplaW1KqkAt5ik="
      ];
    };
  };
}
