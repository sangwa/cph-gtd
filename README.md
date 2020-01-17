## Project description

This project is aimed to deploy [django-todo](https://github.com/shacker/django-todo "django-todo") as a containerized [demo site (GTD)](https://github.com/shacker/gtd "demo site (GTD)") in Kubernetes.

The `docker` subdirectory contains `Dockerfile` required to build the container image and settings overrides for Django to connect to the PostgreSQL database and enable proper operation in the container environment (disabling Host header checks).

The `helm` subdirectory contains a helm chart that is used to deploy the service to a Kubernetes cluster.
The name of the image that the chart expects by default is `cph-gtd:latest`
The chart deploys:
* A `StatefulSet` with a single replica of the official PostgreSQL image that stores its data in a `PersistentVolume`. For simplicity no redundancy is provided for this service.
* A `Deployment` with two replicas of the pre-built image of the demo GTD site. An init container performs necessary database migrations required to initialize the database.
* A `NodePort` service to expose the demo site. For simplicity, ingress controllers are not used in this demo.
* Necessary `Secret` and `ConfigMap` resources required to properly run the pods.

## Installation instructions

### 1. Setting up minikube
Minikube is used as a Kubernetes distribution for this project for the sake of simplicity.
If you don't have minikube installed on your system, please follow [the installation instructions](https://minikube.sigs.k8s.io/docs/start/ "the installation instructions").

### 2. Setting up a docker registry
We will also need to make the docker image of the demo site availabel in the minikube's Kubernetes. To do so, we'll have to use the built-in docker registry of minikube.

First, enable the registry addon:

	minikube addons enable registry

Then you have to whitelist this local registry in the docker daemon on your workstation to be able to push images there. Run

	minikube ip

to retrieve the IP address of the registry (for example, `192.168.64.4`). Then use [the following instructions](https://docs.docker.com/registry/insecure/#deploy-a-plain-http-registry "the following instructions") to add that IP, port 5000 (for example, `192.168.64.4:5000`) to the list of insecure registries. You'll have to restart the docker daemon to apply these changes.

### 3. Building the image

From the root of the working copy of the repo, issue the following commands:

    docker build -t $(minikube ip):5000/cph-gtd:latest ./docker
    docker push $(minikube ip):5000/cph-gtd:latest

### 4. Deploying with helm

[Follow the instructions](https://github.com/helm/helm#install) to install helm 3.
Then, from the root of the working copy of the repo, issue the following command:

    helm upgrade --install cph-gtd ./helm --wait --timeout 300s

### 5. Accessing the site

After the deployed pods become ready, you can access the demo site via the nodeport exposed by minikube.
Issue the command:

	minikube service list

to see the direct link to the site (or use the previously retrieved minikube IP and port 31500, for example `http://192.168.64.4:31500`).

### 6. (Optional) Populating fake data

The site is now up but you can't actually use it because its database is empty. Populating test data automatically would be complicated for this setup (and also dangerous in case of a real deployment), so you can do it manually if you wish.

First, retrieve the name of any pod running the application:

	kubectl get po -l app=cph-gtd,tier=app

Let's say the name of the first pod is `cph-gtd-app-984cd4d57-5bbg9`. Then issue the following command:

	kubectl exec -it cph-gtd-app-984cd4d57-5bbg9 pipenv run ./manage.py hopper

After that you will be able to login with the user information provided on the main page of the demo site.
