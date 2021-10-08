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

Just a [small program](./app.py) using Python language that prints every 30 seconds (configurable through the `INTERVAL` env var) the following data in json format: RX/TX packets, bytes and errors of the default network interface.

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

and for the deployment to kubernetes I strongly recommend you to use kustomize

```sh
cd /path/to/the/project/
# if you wanna change the image use the command  kustomize edit set image <image>=<newimage>:<newtag>
# default files
kubectl apply -k k8s
# Overlays
kubectl apply -k k8s/overlays/dev/
```

if you only want to test the application you can deploy the [`minimal_k8s.yaml`](./k8s/minimal_k8s.yaml) file after checking that the [deployment image](./k8s/minimal_k8s.yaml#L46) is pointing to the correct value

```sh
cd /path/to/the/project/
kubectl apply -f k8s/minimal_k8s.yaml  # notice the difference with -f instad of -k
```

## Usage

just use the browser to http://0.0.0.0:5000/ or you can also use `curl` :)

```sh
curl http://0.0.0.0:5000/ | jq # jq must be installed (no needed)
```

## Monitoring

The [application expose](./app.py#L59) a dummy healthcheck under the following path http://0.0.0.0:5000/healthz

## Maintainers

| Name | Email | Status |
|-|-|-|
| Daniel Ramirez| dxas90@gmail.com| active |

## Original Resources

- [.gitlab-ci-template.yml](https://github.com/dxas90/learn/blob/develop/.gitlab-ci-template.yml)
- [.gitlab-ci.yml](https://github.com/dxas90/learn/blob/develop/.gitlab-ci.yml)
- [Dockerfile](https://github.com/dxas90/hugtor/blob/main/Dockerfile)
- [gunicorn](https://github.com/dxas90/hugtor/blob/main/gunicorn.conf.py)
- [version-validation](https://gist.github.com/dxas90/809116d5d3b478665979b78c251e53c1)
- [minimal_k8s.yaml](https://github.com/dxas90/learn/blob/e689ce5de0c81cdf5ad27719d9e7b784c9f949d0/k8s/deployment.yaml)
- [k8s](https://github.com/dxas90/learn/tree/develop/k8s)
