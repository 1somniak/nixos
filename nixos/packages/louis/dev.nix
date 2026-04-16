{ pkgs, ... }:

{
  users.users.louis.packages = with pkgs; [
    gcc
    bison
    flex
    fontforge
    makeWrapper
    pkg-config
    gnumake
    libiconv
    autoconf
    automake
    libtool
    criterion
    pre-commit
    libpcap
    bear
    gdb
    llvmPackages_20.clang-unwrapped
    rocmPackages.llvm.clang-unwrapped

    typst
    (python3.withPackages (ps: with ps; [
      numpy
      pandas
      scipy
      plotly
      requests
    ]))
    nodejs_24

    qemu
    kvmtool
    hugo
    jetbrains.idea
    jdk21_headless
    maven

    docker
    postgresql

    file
    ghidra
    wineWowPackages.stable
  ];
}
