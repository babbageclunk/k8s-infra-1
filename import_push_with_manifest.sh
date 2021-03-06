#!/bin/bash
ARCHS=$(echo $2 | tr -d 'linux/' | tr ',' ' ')
for platform in $ARCHS; do
    DOCKER_TAG=$(echo $1 | tr '+' '_')
    wget https://storage.googleapis.com/kubernetes-release-dev/ci/${1}/kubernetes-server-linux-${platform}.tar.gz -O /tmp/kubernetes-server-linux-${platform}.tar.gz
    mkdir -p /tmp/kubernetes-${platform}
    tar -xvf /tmp/kubernetes-server-linux-${platform}.tar.gz -C /tmp/kubernetes-${platform} 
    docker load -i /tmp/kubernetes-${platform}/kubernetes/server/bin/kube-apiserver.tar
    docker load -i /tmp/kubernetes-${platform}/kubernetes/server/bin/kube-controller-manager.tar
    docker load -i /tmp/kubernetes-${platform}/kubernetes/server/bin/kube-proxy.tar
    docker load -i /tmp/kubernetes-${platform}/kubernetes/server/bin/kube-scheduler.tar
    docker tag k8s.gcr.io/kube-apiserver-${platform}:$DOCKER_TAG $3/kube-apiserver-${platform}:$DOCKER_TAG
    docker tag k8s.gcr.io/kube-controller-manager-${platform}:$DOCKER_TAG $3/kube-controller-manager-${platform}:$DOCKER_TAG
    docker tag k8s.gcr.io/kube-proxy-${platform}:$DOCKER_TAG $3/kube-proxy-${platform}:$DOCKER_TAG
    docker tag k8s.gcr.io/kube-scheduler-${platform}:$DOCKER_TAG $3/kube-scheduler-${platform}:$DOCKER_TAG
    docker push $3/kube-apiserver-${platform}:$DOCKER_TAG
    docker push $3/kube-controller-manager-${platform}:$DOCKER_TAG
    docker push $3/kube-proxy-${platform}:$DOCKER_TAG
    docker push $3/kube-scheduler-${platform}:$DOCKER_TAG
done
manifest-tool push from-args --platforms $2 -template $3/kube-apiserver-ARCH:$DOCKER_TAG --target $3/kube-apiserver:$DOCKER_TAG
manifest-tool push from-args --platforms $2 -template $3/kube-controller-manager-ARCH:$DOCKER_TAG --target $3/kube-controller-manager:$DOCKER_TAG
manifest-tool push from-args --platforms $2 -template $3/kube-proxy-ARCH:$DOCKER_TAG --target $3/kube-proxy:$DOCKER_TAG
manifest-tool push from-args --platforms $2 -template $3/kube-scheduler-ARCH:$DOCKER_TAG --target $3/kube-scheduler:$DOCKER_TAG
