{
  description = "My PhD thesis";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
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
          set -E

          export PATH=${pkgs.python311Packages.pygments}/bin:$PATH

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
          ${full-texlive}/bin/latexdiff --math-markup=whole -t CFONT sent.tex book.tex > diff.tex
          ${full-texlive}/bin/latexmk -f -pdf -lualatex -shell-escape -interaction=nonstopmode -output-directory=build book.tex
          ${full-texlive}/bin/latexmk -f -pdf -lualatex -shell-escape -interaction=nonstopmode -output-directory=build diff.tex
          mv build/book.pdf build/diff.pdf .
        '';
        ugent2016 = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "ugent2016";
          version = "0.10.0";
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
              setspace
              ulem
            ];
            tlType = "run";
          };

          src = pkgs.fetchurl {
            url = "https://github.com/niknetniko/ugent2016/releases/download/${finalAttrs.version}/ugent2016.zip";
            hash = "sha256-70/5WHljZwbB//CiKy5AKuVTpwyK2BmbPD/Z4lQwPc8=";
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
            pkgs.nixpkgs-fmt
            pkgs.python310Packages.pygments
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
          ];
        };
        packages.build-diffed = build-diffed;
      }
    );
}
