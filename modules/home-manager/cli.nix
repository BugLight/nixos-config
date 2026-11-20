{inputs, ...}: {
  flake.modules.homeManager.cli.imports = with inputs.self.modules.homeManager; [
    cli-tools
    git
  ];
}
