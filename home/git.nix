{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "T0modachi";
        mail = "jvergarava@gmail.com";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-decoration-style = "none";
        file-style = "bold yellow ul";
      };
      features = "decorations";
      whitespace-error-style = "22 reverse";
    };
  };
}
