aws_region        = "us-east-2"
environment_name  = "dev"
node_desired_size = 3
node_min_size     = 3
node_max_size     = 3
enable_jenkins    = false

vpc_cidr = "10.10.0.0/16"

public_subnet_cidrs = [
  "10.10.1.0/24",
  "10.10.2.0/24"
]

private_subnet_cidrs = [
  "10.10.11.0/24",
  "10.10.12.0/24"
]

availability_zones = [
  "us-east-2a",
  "us-east-2b"
]

cluster_name = "tc2-dev-cluster"

repository_name = "tc2-dev-node-app"