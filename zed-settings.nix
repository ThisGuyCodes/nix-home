{ }:
{
  features = {
    edit_prediction_provider = "zed";
  };
  format_on_save = "on";
  vim_mode = true;
  journal = {
    path = "-";
    hour_format = "hour24";
  };
  tabs = {
    git_status = true;
  };
  relative_line_numbers = true;
  soft_wrap = "editor_width";
  preferred_line_length = 120;
  wrap_guides = [
    80
    120
  ];
  lsp = {
    typos.initialization_options.diagnosticSeverity = "Hint";
    nil.initialization_options.formatting.command = [ "nixfmt" ];
    terraform-ls.initialization_options = {
      experimentalFeatures.prefillRequiredFields = true;
    };
  };
  agent = {
    always_allow_tool_actions = true;
    default_model = {
      provider = "zed";
      model = "claude-sonnet-4-5-thinking";
    };
  };
  context_servers = {
    # Github = {
    #   source = "custom";
    #   command = "podman";
    #   args = [
    #     "run"
    #     "-i"
    #     "--rm"
    #     "-e"
    #     "GITHUB_PERSONAL_ACCESS_TOKEN"
    #     "ghcr.io/github/github-mcp-server"
    #   ];
    #   env = {
    #     GITHUB_PERSONAL_ACCESS_TOKEN = "NOOP";
    #   };
    # };
    "Cloudflare Docs" = {
      source = "custom";
      command = "npx";
      args = [
        "-y"
        "mcp-remote"
        "https://docs.mcp.cloudflare.com/sse"
      ];
      env = null;
    };
  };
}
