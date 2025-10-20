import os
import socket
import psutil
import time
import platform

# Helper to safely get environment variables
def get_env(var, default="N/A"):
    return os.environ.get(var) or default

# Hostname
def get_hostname():
    try:
        return socket.gethostname()
    except:
        return "N/A"

# Total CPU cores
def get_total_cpu():
    try:
        return psutil.cpu_count(logical=True)
    except:
        return "N/A"

# CPU usage percent
def get_cpu_usage():
    try:
        return f"{psutil.cpu_percent(interval=1)}%"
    except:
        return "N/A"

# Total memory in MB
def get_total_memory():
    try:
        return f"{round(psutil.virtual_memory().total / (1024*1024))} MB"
    except:
        return "N/A"

# Memory usage percent
def get_memory_usage():
    try:
        return f"{psutil.virtual_memory().percent}%"
    except:
        return "N/A"

# Uptime in HH:MM:SS
def get_uptime():
    try:
        return time.strftime("%H:%M:%S", time.gmtime(time.time() - psutil.boot_time()))
    except:
        return "N/A"

# OS info
def get_os_name():
    try:
        return platform.system()
    except:
        return "N/A"

def get_os_version():
    try:
        return platform.version()
    except:
        return "N/A"

# Kernel version
def get_kernel_version():
    try:
        return platform.release()
    except:
        return "N/A"

# Architecture
def get_architecture():
    try:
        return platform.machine()
    except:
        return "N/A"

# IP addresses (without netifaces)
def get_ip_addresses():
    try:
        hostname = socket.gethostname()
        ips = socket.gethostbyname_ex(hostname)[2]
        return ", ".join(ips) if ips else "N/A"
    except:
        return "N/A"

# Disk usage
def get_disk_usage():
    try:
        du = psutil.disk_usage("/")
        return f"Total: {du.total//(1024*1024)}MB, Used: {du.used//(1024*1024)}MB, Free: {du.free//(1024*1024)}MB"
    except:
        return "N/A"

# Load averages (Linux/Unix)
def get_load_avg():
    try:
        loads = os.getloadavg()
        return f"1min: {loads[0]:.2f}, 5min: {loads[1]:.2f}, 15min: {loads[2]:.2f}"
    except:
        return "N/A"

# Collect all system info in a dictionary
def get_system_info():
    return {
        "hostname": get_hostname(),
        "total_cpu": get_total_cpu(),
        "cpu_usage": get_cpu_usage(),
        "total_memory": get_total_memory(),
        "memory_usage": get_memory_usage(),
        "uptime": get_uptime(),
        "os_name": get_os_name(),
        "os_version": get_os_version(),
        "kernel_version": get_kernel_version(),
        "architecture": get_architecture(),
        "ip_addresses": get_ip_addresses(),
        "disk_usage": get_disk_usage(),
        "load_avg": get_load_avg(),
        "version": get_env("APP_VERSION"),
        "environment": get_env("ENVIRONMENT"),
        "nodename": get_env("NODE_NAME"),
        "podname": get_env("POD_NAME"),
        "pod_namespace": get_env("POD_NAMESPACE"),
        "pod_ip": get_env("POD_IP"),
        "host_ip": get_env("HOST_IP"),
        "service_account": get_env("SERVICE_ACCOUNT"),        
        "developer_name": "Chaitanya Chandra",
        "developer_email": "ChandraChaitanya@icloud.com",
    }
