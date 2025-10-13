#!/bin/sh

sudo ip route add 192.168.4.1 dev enp0s31f6 metric 500
sudo ip route add default via 192.168.4.1 dev enp0s31f6 metric 500
sudo ip route add 192.168.4.0/22 dev enp0s31f6 metric 500
