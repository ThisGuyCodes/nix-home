{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  pkgs,
}:

buildGoModule rec {
  pname = "terragrunt";
  version = "0.75.10";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-lnp1prffufVOG+XV7UAo9Rh3ALE//b87ioPgimgZ5S0=";
  };

  nativeBuildInputs = [
    versionCheckHook
    (pkgs.callPackage ./go-mockery.nix {})
  ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-UhOb1Djup9Cwrv9vYeD/DZe20dwSKYRpJa4V3ZCsPwQ=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gruntwork-io/go-commons/version.Version=v${version}"
    "-extldflags '-static'"
  ];

  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://terragrunt.gruntwork.io";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${version}";
    description = "Thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    mainProgram = "terragrunt";
    license = licenses.mit;
    maintainers = with maintainers; [
      jk
      qjoly
      kashw2
    ];
  };
}
