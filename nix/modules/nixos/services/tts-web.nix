{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.tts-web;

  tts-web-script = pkgs.writeScriptBin "tts-web" ''
    #!${pkgs.python3}/bin/python3
    from flask import Flask, request, render_template_string
    import subprocess

    app = Flask(__name__)

    HTML_TEMPLATE = """
    <!DOCTYPE html>
    <html>
    <head><title>TTS Server</title></head>
    <body>
        <h1>Text-to-Speech</h1>
        <form method="post">
            <input type="text" name="text" placeholder="Enter text to speak" required style="width: 300px;">
            <button type="submit">Speak</button>
        </form>
        {% if message %}
        <p>{{ message }}</p>
        {% endif %}
    </body>
    </html>
    """

    @app.route("/", methods=["GET", "POST"])
    def index():
        message = ""
        if request.method == "POST":
            text = request.form.get("text", "")
            if text:
                try:
                    espeak_proc = subprocess.Popen(
                        ["${pkgs.espeak-ng}/bin/espeak-ng", "--stdout"],
                        stdin=subprocess.PIPE,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                        text=True
                    )
                    
                    aplay_proc = subprocess.Popen(
                        ["${pkgs.alsa-utils}/bin/aplay"],
                        stdin=espeak_proc.stdout,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE
                    )
                    
                    espeak_proc.stdout.close()
                    espeak_proc.communicate(input=text)
                    aplay_proc.wait()
                    
                    message = f"Spoke: {text}"
                except Exception as e:
                    message = f"Error: {str(e)}"
        
        return render_template_string(HTML_TEMPLATE, message=message)

    if __name__ == "__main__":
        app.run(host="0.0.0.0", port=${toString cfg.port})
  '';

in
{
  options.services.tts-web = {
    enable = mkEnableOption "TTS web service";

    port = mkOption {
      type = types.int;
      default = 8080;
      description = "Port to run the TTS web service on";
    };

    user = mkOption {
      type = types.str;
      default = "tts-web";
      description = "User to run the service as";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = "audio";
      extraGroups = [ "audio" ];
    };

    systemd.services.tts-web = {
      description = "TTS Web Service";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "sound.target"
      ];

      serviceConfig = {
        ExecStart = "${tts-web-script}/bin/tts-web";
        User = cfg.user;
        Group = "audio";
        Restart = "always";
        RestartSec = 5;
      };

      environment = {
        PYTHONPATH = "${pkgs.python3.withPackages (ps: with ps; [ flask ])}/${pkgs.python3.sitePackages}";
      };
    };

    environment.systemPackages = with pkgs; [
      espeak-ng
      alsa-utils
      (python3.withPackages (ps: with ps; [ flask ]))
    ];
  };
}
