# Networking Concerns
GCP offers two GKE cluster modes: Standard and Autopilot. You cannot control the nodes in Autopilot 
mode so this module uses the Standard mode. In Standard clusters, you have full control over the 
nodes, and thus, you manage the networking aspects yourself.



The subnet should accommodate the maximum number of nodes that you expect in the cluster and the 
internal load balancer IP addresses across the cluster using the subnet.

You can use the cluster autoscaler to limit the maximum number of nodes.
The Pod and service IP address ranges are represented as distinct secondary ranges of your subnet, 
implemented as alias IP addresses in VPC-native clusters.

Choose wide enough IP address ranges so that you can accommodate all nodes, Pods, and Services for 
the cluster.

Consider the following limitations:

* You can expand primary IP address ranges but you cannot shrink them. These IP address ranges cannot 
be discontiguous.
* You can expand the Pod range by appending additional Pod ranges to the cluster or creating new node 
pools with other secondary Pod ranges.
* The secondary IP address range for Services cannot be expanded or changed over the life of the 
cluster.
* Review the limitations for the secondary IP address range for Pods and Services.

https://cloud.google.com/kubernetes-engine/docs/best-practices/networking