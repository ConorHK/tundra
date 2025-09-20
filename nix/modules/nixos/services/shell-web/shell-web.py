#!/usr/bin/env python3
from flask import Flask, request, render_template_string, redirect, url_for, flash
import subprocess
import sys
import argparse
import os
import glob

app = Flask(__name__)
app.secret_key = "shell-web-secret-key"


def log(msg):
    print(f"[SHELL-WEB] {msg}", flush=True)


HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Shell Script Runner</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { 
            background: #1a1a1a; 
            color: #fff; 
            font-family: monospace; 
            text-align: center; 
            padding: 50px; 
        }
        .script-button { 
            background: #444; 
            color: #fff; 
            border: 1px solid #666; 
            padding: 15px 25px; 
            font-family: monospace; 
            cursor: pointer;
            margin: 10px;
            display: inline-block;
            min-width: 200px;
            text-decoration: none;
        }
        .script-button:hover { 
            background: #555; 
            text-decoration: none;
            color: #fff;
        }
        .message { 
            background: #333; 
            border: 1px solid #555; 
            padding: 10px; 
            margin: 20px auto; 
            max-width: 600px; 
            border-radius: 5px;
        }
        .success { border-color: #27ae60; }
        .error { border-color: #e74c3c; }
        .script-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 15px;
            max-width: 800px;
            margin: 0 auto;
        }
        @media (max-width: 600px) {
            body { padding: 20px; }
            .script-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <h1>Shell Script Runner</h1>
    <p>Click a button to execute a script as user "{{ script_user }}"</p>

    {% with messages = get_flashed_messages(with_categories=true) %}
        {% if messages %}
            {% for category, message in messages %}
                <div class="message {{ category }}">
                    <strong>{{ category.upper() }}:</strong> {{ message }}
                </div>
            {% endfor %}
        {% endif %}
    {% endwith %}

    {% if scripts %}
        <div class="script-grid">
            {% for script in scripts %}
                <form method="post" style="display: inline;">
                    <input type="hidden" name="script" value="{{ script.name }}">
                    <button type="submit" class="script-button">
                        {{ script.display_name }}
                    </button>
                </form>
            {% endfor %}
        </div>
    {% else %}
        <div class="message error">
            No executable scripts found in {{ scripts_dir }}
        </div>
    {% endif %}

    <div style="margin-top: 40px; font-size: 12px; color: #666;">
        Scripts directory: {{ scripts_dir }}
    </div>
</body>
</html>
"""


@app.route("/", methods=["GET", "POST"])
def index():
    scripts_dir = app.config["SCRIPTS_DIR"]
    script_user = app.config["SCRIPT_USER"]

    if request.method == "POST":
        script_name = request.form.get("script", "")
        if script_name:
            script_path = os.path.join(scripts_dir, script_name)

            # Validate script exists and is executable
            if not os.path.isfile(script_path):
                flash("Script not found", "error")
            elif not os.access(script_path, os.X_OK):
                flash("Script is not executable", "error")
            else:
                try:
                    log(f"Executing script: {script_path} as user: {script_user}")

                    result = subprocess.run(
                        ["/run/current-system/sw/bin/bash", script_path],
                        capture_output=True,
                        text=True,
                        timeout=30,  # 30 second timeout
                    )

                    if result.returncode == 0:
                        flash(
                            f"Script '{script_name}' executed successfully", "success"
                        )
                        if result.stdout:
                            flash(f"Output: {result.stdout.strip()}", "success")
                    else:
                        flash(
                            f"Script '{script_name}' failed with exit code {result.returncode}",
                            "error",
                        )
                        if result.stderr:
                            flash(f"Error: {result.stderr.strip()}", "error")

                except subprocess.TimeoutExpired:
                    flash(f"Script '{script_name}' timed out after 30 seconds", "error")
                except Exception as e:
                    flash(f"Error executing script: {str(e)}", "error")

        return redirect(url_for("index"))

    # Get list of executable scripts
    scripts = []
    if os.path.isdir(scripts_dir):
        for script_file in os.listdir(scripts_dir):
            script_path = os.path.join(scripts_dir, script_file)
            if os.path.isfile(script_path) and os.access(script_path, os.X_OK):
                display_name = (
                    script_file.replace(".sh", "")
                    .replace("_", " ")
                    .replace("-", " ")
                    .title()
                )
                scripts.append({"name": script_file, "display_name": display_name})

    scripts.sort(key=lambda x: x["name"])

    return render_template_string(
        HTML_TEMPLATE, scripts=scripts, scripts_dir=scripts_dir, script_user=script_user
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Shell Script Web Runner")
    parser.add_argument("--port", type=int, default=8081, help="Port to run on")
    parser.add_argument(
        "--scripts-dir",
        default="/etc/shell-web/scripts",
        help="Directory containing shell scripts",
    )
    parser.add_argument("--user", default="driver", help="User to execute scripts as")

    args = parser.parse_args()

    app.config["SCRIPTS_DIR"] = args.scripts_dir
    app.config["SCRIPT_USER"] = args.user

    log(f"Starting shell web server on port {args.port}")
    log(f"Scripts directory: {args.scripts_dir}")
    log(f"Script execution user: {args.user}")

    app.run(host="0.0.0.0", port=args.port)
