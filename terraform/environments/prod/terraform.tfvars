aws_region        = "us-east-2"
environment_name  = "prod"
node_desired_size = 2
node_min_size     = 1
node_max_size     = 6
enable_jenkins    = false

vpc_cidr = "10.30.0.0/16"

public_subnet_cidrs = [
  "10.30.1.0/24",
  "10.30.2.0/24"
]

private_subnet_cidrs = [
  "10.30.11.0/24",
  "10.30.12.0/24"
]

availability_zones = [
  "us-east-2a",
  "us-east-2b"
]

cluster_name = "tc2-prod-cluster"

repository_name = "tc2-prod-node-app"

# Argo CD Git repository configuration
git_repo_url = "https://github.com/1PU2021/Mock-Tech-Challenge.git"
git_branch   = "prod"

jenkins_ami_id            = "ami-06e3c045d79fd65d9"
jenkins_instance_type     = "t3.medium"
jenkins_key_name          = "real-world-sim-key"
jenkins_root_volume_size  = 20