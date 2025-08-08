#!/usr/bin/env python3
from flask import Flask, request, render_template_string, redirect, url_for
import subprocess
import sys
import argparse

app = Flask(__name__)


def log(msg):
    print(f"[TTS] {msg}", flush=True)


HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>blast your thoughts</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
        input[type="range"] {
            -webkit-appearance: none;
            background: #333;
            height: 5px;
            border-radius: 5px;
        }
        input[type="range"]::-webkit-slider-thumb {
            -webkit-appearance: none;
            background: #e74c3c;
            height: 20px;
            width: 20px;
            border-radius: 50%;
            cursor: pointer;
        }
        input[type="range"]::-moz-range-thumb {
            background: #e74c3c;
            height: 20px;
            width: 20px;
            border-radius: 50%;
            cursor: pointer;
            border: none;
        }
        .control-row {
            display: flex;
            align-items: center;
            margin: 10px 0;
            justify-content: center;
        }
        .control-row label {
            width: 80px;
            text-align: right;
            margin-right: 15px;
        }
        .control-row select, .control-row input[type="range"] {
            width: 200px;
            margin-right: 10px;
        }
        .control-row select {
            height: 30px;
        }
        .control-row span {
            width: 30px;
            text-align: left;
        }
        @media (max-width: 600px) {
            body { padding: 20px; }
            input[type="text"] { width: 90%; }
            .control-row { flex-direction: column; align-items: center; }
            .control-row label { width: auto; text-align: center; margin-right: 0; margin-bottom: 5px; }
            .control-row select, .control-row input[type="range"] { width: 90%; margin-right: 0; }
            .control-row span { margin-top: 5px; }
        }
    </style>
</head>
<body>
    <h1>Say anything</h1>
    <form method="post">
        <input type="text" name="text" placeholder="Enter text to speak" required>
        <br><br>
        <div class="control-row">
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
            <span></span>
        </div>
        <div class="control-row">
            <label>Speed:</label>
            <input type="range" name="speed" min="80" max="300" value="140">
            <span id="speed-value">140</span>
        </div>
        <div class="control-row">
            <label>Volume:</label>
            <input type="range" name="amplitude" min="10" max="80" value="50">
            <span id="amp-value">50</span>
        </div>
        <br>
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
    return handle_tts_request(app.config["ESPEAK_PATH"], app.config["APLAY_PATH"])


def handle_tts_request(espeak_path, aplay_path):
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
                    [
                        espeak_path,
                        "--stdout",
                        f"-v{voice}",
                        f"-s{speed}",
                        f"-a{amplitude}",
                    ],
                    stdin=subprocess.PIPE,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True,
                )

                log("Starting aplay process")
                aplay_proc = subprocess.Popen(
                    [aplay_path],
                    stdin=espeak_proc.stdout,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
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

            return redirect(url_for("index"))

    return render_template_string(HTML_TEMPLATE, message=message)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="TTS Web Server")
    parser.add_argument("--port", type=int, default=8080, help="Port to run on")
    parser.add_argument("--espeak-path", default="espeak-ng", help="Path to espeak-ng")
    parser.add_argument("--aplay-path", default="aplay", help="Path to aplay")
    args = parser.parse_args()

    app.config["ESPEAK_PATH"] = args.espeak_path
    app.config["APLAY_PATH"] = args.aplay_path

    log(f"Starting TTS web server on port {args.port}")
    app.run(host="0.0.0.0", port=args.port)
