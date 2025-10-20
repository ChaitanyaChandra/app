from flask import Flask, jsonify
from flask import render_template
import socket
import mysql.connector
import os
from system_info import get_system_info

app = Flask(__name__)

DB_Host = os.environ.get('DB_Host') or "localhost"
DB_Database = os.environ.get('DB_Database') or "mysql"
DB_User = os.environ.get('DB_User') or "root"
DB_Password = os.environ.get('DB_Password') or "paswrd"

@app.route("/")
def main():
    db_connect_result = False
    err_message = ""
    try:
        mysql.connector.connect(host=DB_Host, database=DB_Database, user=DB_User, password=DB_Password)
        color = '#39b54b'
        db_connect_result = True
    except Exception as e:
        color = '#ff3f3f'
        err_message = str(e)

    return render_template('sql.html', debug="Environment Variables: DB_Host=" + (os.environ.get('DB_Host') or "Not Set") + "; DB_Database=" + (os.environ.get('DB_Database')  or "Not Set") + "; DB_User=" + (os.environ.get('DB_User')  or "Not Set") + "; DB_Password=" + (os.environ.get('DB_Password')  or "Not Set") + "; " + err_message, db_connect_result=db_connect_result, name=socket.gethostname(), color=color)

@app.route("/spec")
def spec():
    info = get_system_info()
    return render_template("spec.html", info=info)

@app.route("/health")
def health():
    info = get_system_info()
    return jsonify(info)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
