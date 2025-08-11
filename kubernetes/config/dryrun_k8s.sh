#!/bin/bash

# Enable alias expansion
shopt -s expand_aliases
alias kubectl="microk8s kubectl"

kubectl apply -f k8s.yml
