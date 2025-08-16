{ config, ...}: {
  services.nginx = {
    enable = true;
    virtualHosts."nullanoid.net" = {
      # enableACME = true;
      # forceSSL = true;
      root = "/var/www/nullanoid.net";
      # for the record this didnt work like AT ALL LMAO
      locations."/kristal_web".extraConfig = ''
        add_header "Cross-Origin-Opener-Policy" "same-origin";
        add_header "Cross-Origin-Embedder-Policy" "require-corp";
      '';
    };
  };
}