{ pkgs ? import <nixpkgs> {} }:
let
  stdenv = pkgs.stdenv;
  SqlRender = with pkgs.rPackages;
    buildRPackage{
        name = "SqlRender";
        src = pkgs.fetchFromGitHub {
          owner = "OHDSI";
          repo = "SqlRender";
          rev = "1f3fe73b2e3bb4dcce7db713366ac934b47d460f";
          sha256 = "0kk9vdx9dpy74is4jq99nn9j2mrmk2032rgnpinxrzxw3xyx5wzz";
        };
        propagatedBuildInputs = with pkgs.rPackages; [
          rJava rlang
        ];
      };
  Andromeda = with pkgs.rPackages;
    buildRPackage{
        name = "Andromeda";
        src = pkgs.fetchFromGitHub {
          owner = "OHDSI";
          repo = "Andromeda";
          rev = "048d7397b09fa6750b08908aedbd5c3cc6d9d8ec";
          sha256 = "1m9bqw4hwr82887rfd1rxcksbgy3c9ng1k7a1m9bajsqxqlrggi6";
        };
        propagatedBuildInputs = with pkgs.rPackages; [
          dplyr RSQLite DBI zip dbplyr tidyselect cli rlang pillar hms
        ];
      };
  Cyclops = with pkgs.rPackages;
    buildRPackage{
        name = "Cyclops";
        src = pkgs.fetchFromGitHub {
          owner = "OHDSI";
          repo = "Cyclops";
          rev = "75ab6624719e7bf193e744ad6061962c7a008d5c";
          sha256 = "0vczx09wmc31q94wfps34k63vrdvffan19mh8pkqgsd1xdcggkwz";
        };
        propagatedBuildInputs = with pkgs.rPackages; [
          rlang Matrix Rcpp Andromeda dplyr survival bit64 BH RcppEigen
        ];
      };
  FeatureExtraction = with pkgs.rPackages;
    buildRPackage{
        name = "FeatureExtraction";
        src = pkgs.fetchFromGitHub {
          owner = "OHDSI";
          repo = "FeatureExtraction";
          rev = "7e615050508bd1915e8437cf98fceacacbda4b9c";
          sha256 = "0dkm9frnymwgxivdnq1jpsnc3zj59rjk4kys15hvyr0pndl470qm";
        };
        propagatedBuildInputs = with pkgs.rPackages; [
          DatabaseConnector Andromeda dplyr rJava jsonlite SqlRender
          ParallelLogger cli pillar readr rlang RSQLite DBI
        ];
      };
    PatientLevelPrediction = with pkgs.rPackages;
      buildRPackage {
        name = "PatientLevelPrediction";
        src = pkgs.fetchFromGitHub {
          owner = "OHDSI";
          repo = "PatientLevelPrediction";
          rev = "eedce1f3b3bc12aa080bbad04dd144f5afb42e51";
          sha256 = "1mb7y12azpr5sh8y22qpl84ys4kfs1a7cikg8vkv588hiy5h0yrh";
        };
        propagatedBuildInputs = with pkgs.rPackages; [
          Andromeda benchmarkme bit64 Cyclops DatabaseConnector dplyr ggplot2
          gridExtra Hmisc magrittr Matrix ParallelLogger PRROC Rcpp reshape2
          reticulate rlang rms RSQLite slam SqlRender survival tibble tidyr
          zeallot FeatureExtraction
        ];
      };
    CohortMethod = with pkgs.rPackages;
      buildRPackage {
        name = "CohortMethod";
        src = pkgs.fetchFromGitHub {
          owner = "OHDSI";
          repo = "CohortMethod";
          rev = "79b86e4435f66825cecfc8e518d0d1d034d3d4ef";
          sha256 = "1dqdhbqhaqji7vvpgi96zm9ql8b180iqxc19y545vhg38llbhaqh";
        };
        propagatedBuildInputs = with pkgs.rPackages; [
          DatabaseConnector Cyclops FeatureExtraction Andromeda ggplot2
          gridExtra readr plyr dplyr rlang cli pillar Rcpp SqlRender survival
          ParallelLogger bit64
        ];
      };
    DatabaseConnector = with pkgs.rPackages;
      buildRPackage {
        name = "DatabaseConnector";
        src = pkgs.fetchFromGitHub {
          owner = "OHDSI";
          repo = "DatabaseConnector";
          rev = "8a34f01d92a11832cb2bdb07e44385f33e428802";
          sha256 = "1mxgk0mkdscc3nsky5j9vrsykyy551fjjp4dfr5arnkca4c5d5wr";
        };
        propagatedBuildInputs = with pkgs.rPackages; [
          rJava SqlRender stringr rlang DBI urltools bit64
        ];
      };
      rEnv = pkgs.rWrapper.override {
        packages = with pkgs.rPackages; [
          FeatureExtraction DatabaseConnector Andromeda dplyr rJava jsonlite
          SqlRender ParallelLogger cli pillar readr rlang RSQLite DBI Andromeda
          benchmarkme bit64 Cyclops DatabaseConnector dplyr ggplot2 gridExtra
          Hmisc magrittr Matrix ParallelLogger PRROC Rcpp reshape2 reticulate
          rlang rms RSQLite slam SqlRender survival tibble tidyr zeallot
          PatientLevelPrediction CohortMethod
        ];
      };
in pkgs.mkShell {
  buildInputs = with pkgs; [ 
    neovim git glibcLocales openssl which openssh curl wget 
  ];
  inputsFrom = [ rEnv ];
  shellHook = ''
      mkdir -p "$(pwd)/_libs"
      export R_LIBS_USER="$(pwd)/_libs"
    '';
    GIT_SSL_CAINFO = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    LOCALE-ARCHIVE = stdenv.lib.optionalString stdenv.isLinux "${pkgs.glibcLocales}/lib/locale/locale-archive";
}
