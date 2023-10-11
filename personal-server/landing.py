import os
import yaml
import random
import socket
from flask import Flask, request, redirect, url_for, render_template, Response, make_response

# Global variable
with open(os.path.join('config', 'config.yml'), 'r') as file:
    cfg = yaml.safe_load(file)
current_working_dir = os.getcwd()
app = Flask(__name__)

@app.route('/', methods=["GET", "POST"])
def home():
    motd = random.sample(cfg['motd'], 1)[0]

    print("Request.method:", request.method)
    if request.method == 'POST':
        if request.form['navigate'] == 'notebook':
            return redirect(url_for('notebook'))
        elif request.form['navigate'] == 'tensorboard':
            return redirect(url_for('tensorboard'))
        elif request.form['navigate'] == 'terminal':
            return redirect(url_for('terminal'))
        else:
            return render_template('home.html', motd=motd)
    elif request.method == 'GET':
        return render_template('home.html', motd=motd)

@app.route('/socket/')
def get_local_ip():
    # Get the local IP address of the host
    try:
        host_name = socket.gethostname()
        local_ip = socket.gethostbyname(host_name)
        return local_ip
    except:
        return None
    
@app.route('/notebook/')
def notebook():
    url = request.headers['Host']
    return redirect(f'http://{url}:{cfg["notebook"]["port"]}')

@app.route('/tensorboard/')
def tensorboard():
    url = request.headers['Host']
    return redirect(f'http://{url}:{cfg["tensorboard"]["port"]}')

@app.route('/terminal/')
def terminal():
    url = request.headers['Host']
    return redirect(f'http://{url}:{cfg["notebook"]["port"]}/terminals/0')

@app.route('/reload/')
def reload():
    global cfg
    with open(os.path.join('config', 'config.yml'), 'r') as file:
        cfg = yaml.safe_load(file)
    return redirect(url_for('home'))

 
# main driver function
if __name__ == '__main__':
    app.run(debug=False, host="0.0.0.0", port=80)