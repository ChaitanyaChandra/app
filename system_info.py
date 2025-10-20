import os
import socket
import psutil
import time

# Helper to safely get environment variables
def get_env(var, default="N/A"):
    return os.environ.get(var) or default

# Hostname
def get_hostname():
    try:
        return socket.gethostname()
    except:
        return "N/A"

# Total CPU
def get_total_cpu():
    try:
        return psutil.cpu_count(logical=True)
    except:
        return "N/A"

# Total memory in MB
def get_total_memory():
    try:
        return f"{round(psutil.virtual_memory().total / (1024*1024))} MB"
    except:
        return "N/A"

# Uptime in HH:MM:SS
def get_uptime():
    try:
        return time.strftime("%H:%M:%S", time.gmtime(time.time() - psutil.boot_time()))
    except:
        return "N/A"

# Collect all system info in a dict
def get_system_info():
    return {
        "hostname": get_hostname(),
        "total_cpu": get_total_cpu(),
        "total_memory": get_total_memory(),
        "uptime": get_uptime(),
        "developer_name": get_env("DEVELOPER_NAME"),
        "version": get_env("APP_VERSION"),
        "env": get_env("ENVIRONMENT"),
        "nodename": get_env("NODE_NAME"),
        "podname": get_env("POD_NAME"),
    }
