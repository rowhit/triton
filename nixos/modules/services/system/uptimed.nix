{pkgs, config, lib, ...}:

let

  inherit (lib) mkOption mkIf singleton;

  inherit (pkgs) uptimed;

  stateDir = "/var/spool/uptimed";

  uptimedUser = "uptimed";

in

{

  ###### interface

  options = {

    services.uptimed = {

      enable = mkOption {
        default = false;
        description = ''
          Uptimed allows you to track your highest uptimes.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.uptimed.enable {

    environment.systemPackages = [ uptimed ];

    users.extraUsers = singleton
      { name = uptimedUser;
        uid = config.ids.uids.uptimed;
        description = "Uptimed daemon user";
        home = stateDir;
      };

    systemd.services.uptimed = {
      description = "Uptimed daemon";
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -m 0755 -p ${stateDir}
        chown ${uptimedUser} ${stateDir}

        if ! test -f ${stateDir}/bootid ; then
          ${uptimed}/sbin/uptimed -b
        fi
      '';

      script = "${uptimed}/sbin/uptimed";
    };

  };

}
