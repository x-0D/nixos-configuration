let
  curdir = "./";
in
(
  builtins.listToAttrs (
    builtins.filter (x: x != null) (
      map (
        name: if (
          builtins.pathExists ("${curdir}/${name}" + "/flake.nix")
          )
          then {
            name = name;
            value = { url = "${curdir}${name}"; };
          } else null
      ) ( builtins.attrNames (builtins.readDir curdir) )
    )
  )
)
