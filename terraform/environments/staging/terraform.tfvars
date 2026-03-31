aws_region        = "us-east-2"
environment_name  = "teststaging"
node_desired_size = 2
node_min_size     = 1
node_max_size     = 6
enable_jenkins    = true

vpc_cidr = "10.20.0.0/16"

public_subnet_cidrs = [
  "10.20.1.0/24",
  "10.20.2.0/24"
]

private_subnet_cidrs = [
  "10.20.11.0/24",
  "10.20.12.0/24"
]

availability_zones = [
  "us-east-2a",
  "us-east-2b"
]

cluster_name = "tc2-teststaging-cluster"

repository_name = "tc2-teststaging-node-app"

jenkins_ami_id           = "ami-06e3c045d79fd65d9"
jenkins_instance_type    = "t3.medium"
jenkins_key_name         = "real-world-sim-key"
jenkins_root_volume_size = 20