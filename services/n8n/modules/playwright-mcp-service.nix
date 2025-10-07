{ config, lib, pkgs, ... }:

let
  cfg = config.services.playwright-mcp;
in
{
  options.services.playwright-mcp = {
    enable = lib.mkEnableOption "Playwright MCP Server";
    package = lib.mkPackageOption pkgs "playwright-mcp" { };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8931;
      description = "Port to listen on for SSE transport";
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Host to bind server to. Use 0.0.0.0 to bind to all interfaces";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.playwright-mcp = {
      description = "Playwright MCP Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "playwright-mcp";
        WorkingDirectory = "/var/lib/playwright-mcp";
        ExecStart = "${lib.getExe cfg.package} --port ${toString cfg.port} --host ${cfg.host} --headless";
        Restart = "on-failure";
        
        # Security hardening
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
      };
    };
  };
}
