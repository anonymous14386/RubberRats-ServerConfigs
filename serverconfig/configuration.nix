{ ... }: {
  imports = [
  
    ./hardware-configuration.nix
  
    (builtins.fetchTarball {
      # Pick a release version you are interested in and set its hash, e.g.
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-23.11/nixos-mailserver-nixos-23.11.tar.gz";
      sha256 = "122vm4n3gkvlkqmlskiq749bhwfd0r71v6vcmg1bbyg4998brvx8";
    })
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "www";
  networking.domain = "rubberroomwithrats.com";

  networking.firewall.enable = false;

  #TODO autofetch the keys from our github profiles

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFecTaDusQuqN5tWYitmFMqZEbBMeZA8SWLKOtlLE5tI psychopathy@psychopathy-desktop''
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5432hWcdfQX8icuV1W4xV63NB9uQ4yUaJztTXX5qdT''
  ];


  #PROSODY SERVER

  #NGINX
  services.nginx = {
    enable = true;
   #Recomended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    
    virtualHosts."localhost" = {

      root = "/var/www/www.rubberroomwithrats.com";

    };
  };
 
  # mailserver setup
  mailserver = {
    enable = true;
    fqdn = "mail@rubberroomwithrats.com";
    domains = [ "rubberroomwithrats.com" ];

    loginAccounts = {
      "admin@exmaple.com" = {
        hashedPasswordFile = "/home/mallPassHash.txt";
        aliases = ["postmaster@rubberroomwithrats.com];
      };
      "psychopathy@exmaple.com" = {
        hashedPasswordFile = "/home/psychopathyEmailHash.txt";
        aliases = ["psychopathy@rubberroomwithrats.com];
      };
    };
    certificateScheme = "acme-nginx"
  };


  }


  # acme setup
  security.acme = {
    email = "postmaster@rubberroomwithrats.com";
    acceptTerms = true;
    certs = {
      "rubberroomwithrats.com" = {
       webroot = "/var/www/www.rubberroomwithrats.com";
       email = "root@rubberroomwithrats.com";
       extraDomainNames = [ 
        "xmpp.rubberroomwithrats.com" 
        "conference.rubberroomwithrats.com" 
        "upload.rubberroomwithrats.com" 
        "www.rubberroomwithrats.com"
        "mail.rubberroomwithrats.com"
       ];
      };
    };
  };

 
  system.stateVersion = "23.11";
}
