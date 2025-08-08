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
    import sys

    app = Flask(__name__)

    def log(msg):
        print(f"[TTS] {msg}", flush=True)

    HTML_TEMPLATE = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>TTS Server</title>
        <style>
            body { 
                background: #1a1a1a; 
                color: #fff; 
                font-family: monospace; 
                text-align: center; 
                padding: 50px; 
            }
            input { 
                background: #333; 
                color: #fff; 
                border: 1px solid #555; 
                padding: 10px; 
                font-family: monospace; 
                width: 300px; 
            }
            button { 
                background: #444; 
                color: #fff; 
                border: 1px solid #666; 
                padding: 10px 20px; 
                font-family: monospace; 
                cursor: pointer; 
            }
            button:hover { background: #555; }
        </style>
    </head>
    <body>
        <h1>Text-to-Speech</h1>
        <form method="post">
            <input type="text" name="text" placeholder="Enter text to speak" required>
            <br><br>
            <label>Voice:</label>
            <select name="voice" style="background: #333; color: #fff; border: 1px solid #555; padding: 5px; font-family: monospace;">
                <option value="en-gb-scotland">English_(Scotland)</option>
                <option value="en-us">English_(America)</option>
                <option value="en-gb">English_(Great_Britain)</option>
                <option value="fr-fr">French_(France)</option>
                <option value="de">German</option>
                <option value="es">Spanish_(Spain)</option>
                <option value="it">Italian</option>
                <option value="ja">Japanese</option>
                <option value="ru">Russian</option>
                <option value="zh">Chinese_(Mandarin)</option>
            </select>
            <br><br>
            <label>Speed:</label>
            <input type="range" name="speed" min="80" max="300" value="140" style="width: 200px;">
            <span id="speed-value">140</span>
            <br><br>
            <label>Volume:</label>
            <input type="range" name="amplitude" min="10" max="80" value="50" style="width: 200px;">
            <span id="amp-value">50</span>
            <br><br>
            <button type="submit">Speak</button>
        </form>
        <script>
            document.querySelector('input[name="speed"]').oninput = function() {
                document.getElementById('speed-value').textContent = this.value;
            }
            document.querySelector('input[name="amplitude"]').oninput = function() {
                document.getElementById('amp-value').textContent = this.value;
            }
        </script>
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
            voice = request.form.get("voice", "en-gb-scotland")
            speed = min(300, max(80, int(request.form.get("speed", "140"))))
            amplitude = min(80, max(10, int(request.form.get("amplitude", "50"))))
            log(f"TTS request: '{text}' voice={voice} speed={speed} amp={amplitude}")
            if text:
                try:
                    log("Starting espeak-ng process")
                    espeak_proc = subprocess.Popen(
                        ["${pkgs.espeak-ng}/bin/espeak-ng", "--stdout", f"-v{voice}", f"-s{speed}", f"-a{amplitude}"],
                        stdin=subprocess.PIPE,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                        text=True
                    )
                    
                    log("Starting aplay process")
                    aplay_proc = subprocess.Popen(
                        ["${pkgs.alsa-utils}/bin/aplay"],
                        stdin=espeak_proc.stdout,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE
                    )
                    
                    espeak_proc.stdout.close()
                    espeak_stdout, espeak_stderr = espeak_proc.communicate(input=text)
                    aplay_stdout, aplay_stderr = aplay_proc.communicate()
                    
                    if aplay_proc.returncode != 0:
                        message = f"Aplay error: {aplay_stderr.decode()}"
                    else:
                        message = f"Spoke: {text}"
                except Exception as e:
                    message = f"Error: {str(e)}"
        
        return render_template_string(HTML_TEMPLATE, message=message)

    if __name__ == "__main__":
        log("Starting TTS web server on port ${toString cfg.port}")
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
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = "audio";
      extraGroups = [ "audio" "pipewire" ];
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
