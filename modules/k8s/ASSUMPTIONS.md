# Use VPC-native clusters
We recommend that you use VPC-native clusters. VPC-native clusters use alias IP address ranges on GKE nodes and are required for clusters based on VPC Network Peering, for clusters on Shared VPCs, and have many other benefits. For clusters created in the Autopilot mode, VPC-native mode is always on and cannot be turned off.

VPC-native clusters scale more easily than routes-based clusters without consuming Google Cloud routes and so are less susceptible to hitting routing limits.

The advantages to using VPC-native clusters go hand-in-hand with alias IP support. For example, network endpoint groups (NEGs) can only be used with secondary IP addresses, so they are only supported on VPC-native clusters.


https://cloud.google.com/kubernetes-engine/docs/best-practices/networking#vpc-native-clusters