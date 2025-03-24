# vim: ts=2 sts=0 sw=0 et
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  outputs =
    { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      #{{{ copyFarm
      # copied from nixpkgs linkFarm, modified
      copyFarm =
        name: entries:
        let
          entries' =
            if (lib.isAttrs entries) then
              entries
            # We do this foldl to have last-wins semantics in case of repeated entries
            else if (lib.isList entries) then
              lib.foldl (a: b: a // { "${b.name}" = b.path; }) { } entries
            else
              throw "linkFarm entries must be either attrs or a list!";

          linkCommands = lib.mapAttrsToList (name: path: ''
            mkdir -p "$(dirname ${lib.escapeShellArg "${name}"})"
            cp -r ${lib.escapeShellArg "${path}"} ${lib.escapeShellArg "${name}"}
          '') entries';
        in
        pkgs.runCommand name
          {
            preferLocalBuild = true;
            allowSubstitutes = false;
            passthru.entries = entries';
          }
          ''
            mkdir -p $out
            cd $out
            ${lib.concatStrings linkCommands}
          '';
      #}}}
      pack = builtins.fromTOML (builtins.readFile ./pack.toml);
      zipOf =
        name: path:
        pkgs.runCommand name
          {
            buildInputs = [ pkgs.zip ];
          }
          ''
            cd ${path}
            zip -9r $out .
          '';
      mkPrismPack =
        name: src:
        zipOf "eazs-live-${name}.zip" (
          copyFarm "eazs-live-${name}" {
            "icon.png" = ./icon.png;
            "packwiz-installer-bootstrap.jar" = pkgs.fetchurl {
              url = "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar";
              hash = "sha256:qPuyTcYEJ46X9GiOgtPZGjGLmO/AjV2/y8vKtkQ9EWw=";
            };
            "instance.cfg" = (pkgs.formats.ini { }).generate "instance.cfg" {
              General = {
                name = pack.name;
                ConfigVersion = "1.2";
                InstanceType = "OneSix";
                OverrideCommands = true;
                PreLaunchCommand = "$INST_JAVA -jar $INST_DIR/packwiz-installer-bootstrap.jar -s both ${src}";
              };
            };
            "mmc-pack.json" = pkgs.writers.writeJSON "mmc-pack.json" {
              formatVersion = 1;
              components = [
                {
                  uid = "net.minecraft";
                  version = pack.versions.minecraft;
                  important = true;
                }
                {
                  uid = "net.fabricmc.fabric-loader";
                  version = pack.versions.fabric;
                  important = true;
                }
              ];
            };
          }
        );
    in
    {
      formatter.${pkgs.system} = pkgs.nixfmt-rfc-style;
      packages.${pkgs.system} = rec {
        prismPack = mkPrismPack "current" "${
          if builtins ? getEnv then builtins.getEnv "PWD" else self
        }/pack.toml";
        releasePrismPack = mkPrismPack "release" "https://github.com/PoolloverNathan/eazs-2/raw/main/pack.toml";
      };
    };
}
