{
  description = "My PhD thesis";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, devshell, emacs-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ devshell.overlays.default emacs-overlay.overlays.default ]; config.allowUnfree = true; };
        emacs = pkgs.emacsWithPackagesFromPackageRequires {
          packageElisp = builtins.readFile ./build.el;
          extraEmacsPackages = epkgs: [epkgs.citeproc];
        };
        full-texlive = pkgs.texlive.combine { inherit (pkgs.texlive) scheme-full; inherit ugent2016; };
        build-diffed = pkgs.writeShellScriptBin "build-diffed" ''
          export OSFONTDIR=./fonts/
          PATH=$PATH:${pkgs.python3.withPackages (ps: [ ps.pygments ])}/bin:${pkgs.inkscape}/bin
          set -E
          atexit() {
            git worktree remove -f .sent
            rm book.tex sent.tex diff.tex -f
            rm build -rf
          }
          trap "atexit" EXIT
          ${emacs}/bin/emacs -batch -load build.el
          ${pkgs.git}/bin/git worktree add .sent $(cat .sent-revision)
          pushd .sent
          ${emacs}/bin/emacs -batch -load ../build.el
          mv book.tex ../sent.tex
          popd
          mkdir build
          ${full-texlive}/bin/latexdiff --math-markup=whole -t CFONT -c 'VERBATIMENV=(?:(?:comment)|(?:minted)|(?:luacode[*]?))' sent.tex book.tex | sed "s/%DIF > $//" > diff.tex
          ${full-texlive}/bin/latexmk -f -pdf -lualatex -shell-escape -interaction=nonstopmode -output-directory=build book.tex
          ${full-texlive}/bin/latexmk -f -pdf -lualatex -shell-escape -interaction=nonstopmode -output-directory=build diff.tex
          mv build/book.pdf build/diff.pdf .
        '';
        ugent2016 = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "ugent2016";
          version = "0.12.0";
          passthru = {
            pkgs = [ finalAttrs.finalPackage ];
            tlDeps = with pkgs.texlive; [
              etoolbox
              kvoptions
              xstring
              auxhook
              translations
              fontspec
              pgf
              textcase
              graphics
              geometry
              ulem
            ];
            tlType = "run";
          };

          src = pkgs.fetchurl {
            url = "https://github.com/niknetniko/ugent2016/releases/download/${finalAttrs.version}/ugent2016.zip";
            hash = "sha256-9yax8pH0L9/fNbRM9lOcauYVa6GbxeDwquCMFhLMXpE=";
          };

          nativeBuildInputs = [ pkgs.unzip ];

          sourceRoot = ".";

          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall

            mkdir -p $out
            unzip ugent2016.tds -d $out

            runHook postInstall
          '';

          dontFixup = true;

          meta = with pkgs.lib; {
            description = "Styles for UGent";
            license = licenses.unfreeRedistributable;
            maintainers = [ ];
            platforms = platforms.all;
          };
        });
      in
      {
        devShells.default = pkgs.devshell.mkShell {
          name = "PhD thesis";
          packages = [
            full-texlive
            pkgs.inkscape
            pkgs.nixpkgs-fmt
            (pkgs.python3.withPackages (ps: [ ps.pygments ]))
          ];
          env = [
            {
              name = "OSFONTDIR";
              value = "./fonts";
            }
          ];
          commands = [
            {
              name = "clean";
              category = "general commands";
              help = "clean directory";
              command = "cat .gitignore | xargs rm";
            }
            {
              name = "revision-sent";
              category = "general commands";
              help = "declare sent revision";
              command = ''
                git rev-parse --short HEAD > .sent-revision
                git commit -m "Sent latest revision" --only .sent-revision
              '';
            }
            {
              name = "build-diffed";
              category = "general commands";
              help = "build a diffed PDF between latest sent revision and current";
              package = build-diffed;
            }
            {
              name = "build";
              category = "general commands";
              help = "build the PDF";
              command = ''
                if [ $# -eq 1 ]
                then
                    builddir=$1
                else
                    builddir=$(mktemp -d --tmpdir=/tmp)
                fi
                sed -i "s/journal = {\([^{].*\)}/journal = {{\1}}/" bibliography.bib
                ${emacs}/bin/emacs -batch -load build.el
                ${full-texlive}/bin/latexmk -f -pdf -lualatex -shell-escape -interaction=nonstopmode -output-directory="''${builddir}" book.tex
                mv "''${builddir}"/book.pdf .
                if ! [ $# -eq 1 ]
                then
                    rm "''${builddir}" -rf
                fi
              '';
            }
            {
              name = "watch-build";
              category = "general commands";
              help = "watch main file and build on change";
              command = ''
                builddir=$(mktemp -d --tmpdir=/tmp)

                trap "rm \"''${builddir}\" -rf; exit 0" SIGINT SIGTERM
                if [ -e book.pdf ]
                then
                  time=$(stat -c %Y book.pdf)
                else
                  time=$(date "+%s")
                  build "''${builddir}" || ${pkgs.libnotify}/bin/notify-send "Build failed"
                fi
                while true
                do
                  while [ "$time" -lt "$(stat -c %Y book.org)" ]
                  do
                    time=$(date "+%s")
                    build "''${builddir}" || ${pkgs.libnotify}/bin/notify-send "Build failed"
                  done
                  time=$(date "+%s")
                  echo "Waiting for change..."
                  ${pkgs.fswatch}/bin/fswatch -1 book.org >/dev/null
                done
              '';
            }
          ];
        };
        packages.build-diffed = build-diffed;
      }
    );
}
