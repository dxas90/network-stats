from flask import Flask, jsonify
import time
import os
app = Flask(__name__)

# https://stackoverflow.com/a/6556951/8997751


def get_default_iface_name_linux() -> str:
    """Read the default gateway directly from /proc."""
    with open("/proc/net/route") as fh:
        for line in fh:
            fields = line.strip().split()
            if fields[1] != '00000000' or not int(fields[3], 16) & 2:
                # If not default route or not RTF_GATEWAY, skip it
                continue
            return fields[0]


def iface_stats(iface: str) -> dict:
    """Read the data for the provided interface"""
    result = {
        "interface": iface,
        "tx": {
            "tx_packets": "",
            "tx_bytes": "",
            "tx_errors": ""
        },
        "rx": {
            "rx_packets": "",
            "rx_bytes": "",
            "rx_errors": ""
        },
    }
    for value in result['tx'].keys():
        with open("/sys/class/net/" + iface + "/statistics/" + value) as fh:
            for line in fh:
                result['tx'][value] = line.strip()

    for value in result['rx'].keys():
        with open("/sys/class/net/" + iface + "/statistics/" + value) as fh:
            for line in fh:
                result['rx'][value] = line.strip()
    return result


@app.route("/")
@app.route("/1/")
def index():
    iface = get_default_iface_name_linux()
    return iface_stats(iface)


@app.route("/ping")
def ping():
    return "pong"


@app.route("/healthz")
def healthz():
    return jsonify({"alive": True})


if __name__ == '__main__':

    INTERVAL = os.getenv("INTERVAL", default=30)
    while True:
        iface = get_default_iface_name_linux()
        print(iface_stats(iface))
        time.sleep(float(INTERVAL))
