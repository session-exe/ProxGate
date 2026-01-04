import os, subprocess
from flask import Flask, render_template, request, jsonify, send_from_directory

app = Flask(__name__)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PM3_PATH = os.path.join(BASE_DIR, "proxmark3/client/proxmark3")
DUMP_DIR = os.path.join(BASE_DIR, "dumps")

# Variável global para manter a pasta atual do terminal Linux
current_sys_dir = BASE_DIR

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

@app.route('/shell', methods=['POST'])
def shell():
    global current_sys_dir
    cmd = request.json.get('cmd').strip()
    
    try:
        # Lógica especial para o comando 'cd'
        if cmd.startswith("cd "):
            target = cmd[3:].strip()
            # Resolve o caminho (trata '..', '~', etc)
            new_path = os.path.abspath(os.path.join(current_sys_dir, target))
            if os.path.exists(new_path) and os.path.isdir(new_path):
                current_sys_dir = new_path
                return jsonify({"output": f"Changed directory to: {current_sys_dir}", "cwd": current_sys_dir})
            else:
                return jsonify({"output": f"bash: cd: {target}: No such directory"})

        # Executa outros comandos na pasta atual guardada
        process = subprocess.run(
            cmd, shell=True, capture_output=True, text=True, timeout=30, cwd=current_sys_dir
        )
        output = process.stdout + process.stderr
        return jsonify({
            "output": output if output else "Comando executado.",
            "cwd": current_sys_dir
        })
    except Exception as e:
        return jsonify({"output": f"Erro: {str(e)}"})

@app.route('/files')
def list_files():
    files = [f for f in os.listdir(DUMP_DIR) if os.path.isfile(os.path.join(DUMP_DIR, f))]
    return jsonify(files)

@app.route('/download/<filename>')
def download(filename):
    return send_from_directory(DUMP_DIR, filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)