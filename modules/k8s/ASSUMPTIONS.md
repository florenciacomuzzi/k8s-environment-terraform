# Use VPC-native clusters
We recommend that you use VPC-native clusters. VPC-native clusters use alias IP address ranges on 
GKE nodes and are required for clusters based on VPC Network Peering, for clusters on Shared VPCs, 
and have many other benefits. For clusters created in the Autopilot mode, VPC-native mode is always 
on and cannot be turned off.

VPC-native clusters scale more easily than routes-based clusters without consuming Google Cloud 
routes and so are less susceptible to hitting routing limits.

The advantages to using VPC-native clusters go hand-in-hand with alias IP support. For example, 
network endpoint groups (NEGs) can only be used with secondary IP addresses, so they are only 
supported on VPC-native clusters.


https://cloud.google.com/kubernetes-engine/docs/best-practices/networking#vpc-native-clusters

max number of pods per node /26 --> two IPs per Pod --> 32 --> lean setup of node pool
secondary pod ranges at cluster level 192.168.0.0/16 --> cut in half 192.168.0.0/17 --> 32k IPs -> cluster default pod address range
192.168.128.0/17 services address range --> 16k max pods for cluster


RFC 1918 space
cluster default pod address range 192.168.0.0/21
services address range 192.168.8.0/22 --> can go up to /27 so 30 services --> up to 1k services with /22
Enable VPC-native traffic routing (uses alias IP)
automatically create secondary range
--> secondary ranges are managed for us

public cluster --> secure with firewall
