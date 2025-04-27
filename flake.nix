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
            contents = path;
          }
          ''
            cd "$contents"
            zip -0r $out .
          '';
      mkUnsupPrismPack =
        name: src:
        zipOf "eazs-br-${name}-unsup.zip" (
          copyFarm "eazs-br-${name}-unsup" {
            "icon.png" = ./icon.png;
            "patches/com.unascribed.unsup.json" = pkgs.fetchurl {
              url = "https://git.sleeping.town/unascribed/unsup/releases/download/v1.0.2/com.unascribed.unsup.json";
              hash = "sha256-SvfPebEN2piWc+VbFWOEwb4lQFC4E9P0mLLFKPiz5MA=";
            };
            "instance.cfg" = builtins.toFile "instance.cfg" "";
            "minecraft/unsup.ini" =
              pkgs.writeText "unsup.ini" # ini
                ''
                  version=1
                  preset=minecraft
                  source_format=packwiz
                  source=${if lib.hasPrefix "/" src then "file://${src}" else src}
                  offer_change_flavors=true

                  [colors]
                  background=24273a
                  title=cad3f5
                  subtitle=a5adcb
                  progress=c6a0f6
                  progress_track=181926
                  dialog=b8c0e0
                  button=c6a0f6
                  button_text=1e2030
                  question=b7bdf8
                  info=7dc4e4
                  warning=f5a97f
                  error=ee99a0

                  [flavors]
                  recipe_viewer=emi
                ''
              // lib.optionalAttrs (lib.hasPrefix "/" src) { nativeBuildInputs = [ src ]; };
            "mmc-pack.json" = pkgs.writers.writeJSON "mmc-pack.json" {
              formatVersion = 1;
              components = [
                {
                  important = true;
                  uid = "net.minecraft";
                  version = "1.20.1";
                  cachedName = "Minecraft";
                  cachedRequires = [
                    {
                      uid = "org.lwjgl3";
                      suggests = "3.3.2";
                    }
                  ];
                  cachedVersion = "1.20.1";
                }
                {
                  uid = "net.fabricmc.fabric-loader";
                  version = pack.versions.fabric;
                  important = true;
                }
                {
                  uid = "com.unascribed.unsup";
                  cachedName = "unsup";
                  cachedVersion = "1.0.2";
                  important = true;
                }
              ];
            };
          }
        );
      mkLegacyPrismPack =
        name: src:
        zipOf "eazs-br-${name}.zip" (
          copyFarm "eazs-br-${name}" {
            "icon.png" = ./icon.png;
            "minecraft/packwiz-installer-bootstrap.jar" = pkgs.fetchurl {
              url = "https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar";
              hash = "sha256:qPuyTcYEJ46X9GiOgtPZGjGLmO/AjV2/y8vKtkQ9EWw=";
            };
            "instance.cfg" = (pkgs.formats.ini { }).generate "instance.cfg" {
              General = {
                name = pack.name;
                ConfigVersion = "1.2";
                InstanceType = "OneSix";
                OverrideCommands = true;
                PreLaunchCommand = ''java -jar packwiz-installer-bootstrap.jar -s both ${src}'';
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
        prismPack = mkUnsupPrismPack "HEAD" (default + /pack.toml);
        releasePrismPack = mkUnsupPrismPack "main" "https://poollovernathan.github.io/eazs-2/pack.toml";
        legacyReleasePrismPack = mkLegacyPrismPack "main" "https://poollovernathan.github.io/eazs-2/pack.toml";

        default =
          pkgs.runCommand "pack"
            {
              buildInputs = [ pkgs.packwiz ];
            }
            ''
              cp -r ${./.} $out
              cd $out
              chmod -R +w .
              packwiz refresh --build
            '';
      };
    };
}
