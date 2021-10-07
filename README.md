# Interface monitor task

## Table of Contents

- [Interface monitor task](#interface-monitor-task)
  - [Table of Contents](#table-of-contents)
- [Description](#description)
  - [Requirements](#requirements)
  - [Install](#install)
  - [Usage](#usage)
  - [Monitoring](#monitoring)
  - [Maintainers](#maintainers)
  - [License](#license)

## Description

Just a small program using Python language that prints every 30 seconds (configurable through the `INTERVAL` env var) the following data in json format: RX/TX packets, bytes and errors of the default network interface.

sample output

```json
{
  "interface": "eth0",
  "rx": {
    "rx_bytes": "2809",
    "rx_errors": "0",
    "rx_packets": "322"
  },
  "tx": {
    "tx_bytes": "367",
    "tx_errors": "0",
    "tx_packets": "36"
  }
}
```

## Requirements

you will need python, docker for the installation

## Install

In order to install the application you can create a python virtual environment just to keep your system clear without unnused python modules.

```sh
cd /path/to/the/project/
python3 -m venv venv
source venv/bin/activate
pip install --no-cache-dir -r requirements.txt
gunicorn -c gunicorn_config.py app:app
# now you should be able to access the web api through http://0.0.0.0:5000/
```

## Usage

just use the browser to http://0.0.0.0:5000/ or you can also use `curl` :)

```sh
curl http://0.0.0.0:5000/ | jq # jq must be installed (no needed)
```

## Monitoring

TODO

## Maintainers

| Name | Email | Status |
|-|-|-|
| Daniel Ramirez| dxas90@gmail.com| active |

## Original Resources

TODO
