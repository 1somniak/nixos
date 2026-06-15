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
    graphviz
    llvmPackages_20.clang-unwrapped
    rocmPackages.llvm.clang-unwrapped

    typst
    tinymist
    (python3.withPackages (ps: with ps; [
    #  numpy
    #  pandas
    #  scipy
    #  plotly
    #  requests
      matplotlib
      yt-dlp
    ]))
    nodejs_24

    qemu
    kvmtool
    hugo
    jdk21
    #jdk21_headless
    #maven

    docker
    postgresql

    gitlab-runner
    gitlab-ci-local
    git-lfs
    freerdp
  ];
}
