{ lib, stdenv, fetchFromGitHub
, doxygen, fontconfig, graphviz-nox, libxml2, pkg-config, which
, systemd }:

stdenv.mkDerivation rec {
  pname = "openzwave";
  version = "2020-11-03";

  # Use fork by Home Assistant because this package is mainly used for python.pkgs.homeassistant-pyozw.
  # See https://github.com/OpenZWave/open-zwave/compare/master...home-assistant:hass for the difference.
  src = fetchFromGitHub {
    owner = "OpenZWave";
    repo = "open-zwave";
    rev = "893e076a1a45af31bf8c69d321646ec5f770b270";
    sha256 = "1695xzfy070rv50lcc9jqahl9g52h9rwp8s9xx1pgk5mmg27hhv8";
  };

  nativeBuildInputs = [ doxygen fontconfig graphviz-nox libxml2 pkg-config which ];

  buildInputs = [ systemd ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    DESTDIR=$out PREFIX= pkgconfigdir=lib/pkgconfig make install $installFlags

    runHook postInstall
  '';

  FONTCONFIG_FILE="${fontconfig.out}/etc/fonts/fonts.conf";
  FONTCONFIG_PATH="${fontconfig.out}/etc/fonts/";

  postPatch = ''
    substituteInPlace cpp/src/Options.cpp \
      --replace /etc/openzwave $out/etc/openzwave
  '';

  fixupPhase = ''
    substituteInPlace $out/lib/pkgconfig/libopenzwave.pc \
      --replace prefix= prefix=$out \
      --replace dir=    dir=$out

    substituteInPlace $out/bin/ozw_config \
      --replace pcfile=${pkg-config} pcfile=$out
  '';

  meta = with lib; {
    description = "C++ library to control Z-Wave Networks via a USB Z-Wave Controller";
    homepage = "http://www.openzwave.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
