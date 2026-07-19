{
  flake.modules.homeManager.opencode = {
    services.ollama = {
      enable = true;
    };

    programs.opencode = {
      enable = true;
      settings = {
        provider.ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options.baseURL = "http://localhost:11434/v1";
          models.qwen3-coder = {
            name = "qwen3-coder";
          };
        };

        model = "ollama/qwen3-coder";
      };
    };
  };
}
