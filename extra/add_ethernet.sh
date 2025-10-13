#!/bin/sudo su

ip route add 192.168.4.1 dev enp0s31f6 metric 500
ip route add default via 192.168.4.1 dev enp0s31f6 metric 500
ip route add 192.168.4.0/22 dev enp0s31f6 metric 500
