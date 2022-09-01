#!/bin/bash

helm install -n service-exchange service-exchange

until helm list --deployed service-exchange | grep -w service-exchange; do sleep 3; done
echo "Check status of service-exchange deployments..."
TIMES=0
while [ $(kubectl get deployments --no-headers | awk '{print $4}'|grep 0|wc -l) -gt 0 ]&&[ ${TIMES} -lt 100 ];do
  TIMES=`expr ${TIMES} + 1`
  echo "Retry ${TIMES} times..."
  sleep 6
done
kubectl get deployments
