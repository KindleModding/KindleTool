{
  stdenv,
  lib,
  pkg-config,
  hostname,
  libarchive,
  nettle,
  zlib,
}:

stdenv.mkDerivation {
  name = "kindletool";
  src = lib.cleanSource ./.;

  nativeBuildInputs = [
    pkg-config
    hostname
  ];

  buildInputs = [
    libarchive
    nettle
    zlib
  ];

  buildPhase = ''
    runHook preBuild

    make -C KindleTool all

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    install -m 755 KindleTool/Release/kindletool $out/bin/kindletool
    install -m 644 KindleTool/kindletool.1 $out/share/man/man1/kindletool.1

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/NiLuJe/KindleTool";
    description = "A tool for creating & extracting Kindle updates and more";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
