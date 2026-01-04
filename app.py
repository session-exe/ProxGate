import os
from flask import Flask, render_template, request, jsonify
import subprocess

app = Flask(__name__)

# Finds the path to the current directory
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Define the path to the executable relative to the app folder
PM3_PATH = os.path.join(BASE_DIR, "proxmark3/client/proxmark3")

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/exec', methods=['POST'])
def execute():
    command = request.json.get('cmd')
    try:
        process = subprocess.run(
            [PM3_PATH, "/dev/ttyACM0", "-c", command],
            capture_output=True, text=True, timeout=60
        )
        return jsonify({"output": process.stdout})
    except Exception as e:
        return jsonify({"output": f"Erro de caminho: {str(e)}"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)