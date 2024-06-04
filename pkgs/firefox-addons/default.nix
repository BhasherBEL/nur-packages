{ lib, ... }@args:

let

  buildFirefoxXpiAddon = lib.makeOverridable (
    {
      stdenv ? args.stdenv,
      fetchurl ? args.fetchurl,
      pname,
      version,
      addonId,
      url,
      sha256,
      meta,
      ...
    }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = {
        inherit addonId;
      };

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    }
  );
in
{
  inherit buildFirefoxXpiAddon;

  packages = {
    "kde_connect" = buildFirefoxXpiAddon {
      pname = "kde-connect";
      version = "0.1.7";
      addonId = "kde-connect@0xc0dedbad.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/3922507/kde_connect-0.1.7.xpi";
      sha256 = lib.fakeSha256;
      meta = {
        homepage = "https://community.kde.org/KDEConnect";
        description = "KDE Connect adds communication between your phone and your computer.";
        license = lib.licenses.gpl3;
        platforms = lib.platforms.all;
      };
    };
  };
}
