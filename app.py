import os, subprocess
from flask import Flask, render_template, request, jsonify, send_from_directory

app = Flask(__name__)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PM3_PATH = os.path.join(BASE_DIR, "proxmark3/client/proxmark3")
DUMP_DIR = os.path.join(BASE_DIR, "dumps")

if not os.path.exists(DUMP_DIR):
    os.makedirs(DUMP_DIR)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/exec', methods=['POST'])
def execute():
    cmd = request.json.get('cmd')
    try:
        env = os.environ.copy()
        env["HOME"] = DUMP_DIR 
        
        process = subprocess.run(
            [PM3_PATH, "/dev/ttyACM0", "-c", cmd],
            capture_output=True, text=True, timeout=60,
            cwd=DUMP_DIR, env=env
        )
        return jsonify({"output": process.stdout})
    except Exception as e:
        return jsonify({"output": str(e)})

@app.route('/files')
def list_files():
    files = [f for f in os.listdir(DUMP_DIR) if os.path.isfile(os.path.join(DUMP_DIR, f))]
    return jsonify(files)

@app.route('/download/<filename>')
def download(filename):
    return send_from_directory(DUMP_DIR, filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)