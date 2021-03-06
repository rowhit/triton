{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    programs.man.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable manual pages and the <command>man</command> command.
      '';
    };

  };


  config = mkIf config.programs.man.enable {

    environment.etc."man_db.conf".text = "";

    environment.systemPackages = [ pkgs.man-db ];

    environment.pathsToLink = [ "/share/man" ];

    environment.outputsToLink = [ "man" ];

    users.extraUsers.man.uid = config.ids.uids.man;
    users.extraGroups.man.gid = config.ids.gids.man;

  };

}
