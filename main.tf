provider "google" {
  credentials = file("path/to/your/service-account-file.json")
  project     = "PROJECT-ID"
  region      = "us-central1"
}

resource "google_compute_instance" "workshop_vm" {
  count        = 20
  name         = "workshop-instance-${format("%02d", count.index)}"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "centos-stream-9-v20240213"
      size  = 10  # Disk size in GB
      type  = "n1-standard-1" # Or "pd-ssd" for SSD storage
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<EOF
#!/bin/bash
# Create the 'workshop' user and add to the 'sudo' group
useradd -m -s /bin/bash workshop
echo "workshop:password" | chpasswd
usermod -aG sudo workshop

# Set up .ssh directory for the 'workshop' user
mkdir -p /home/workshop/.ssh
chmod 700 /home/workshop/.ssh
chown workshop:workshop /home/workshop/.ssh

# Add the public SSH key to the authorized_keys file for SSH access
echo "${file("path/to/terraform-ssh-key.pub")}" > /home/workshop/.ssh/authorized_keys
chmod 600 /home/workshop/.ssh/authorized_keys
chown workshop:workshop /home/workshop/.ssh/authorized_keys

# Create the configuration directory and download the json file
mkdir -p myfile
wget -O myfile/file.json https://github.com/yourusername/yourrepository/raw/branchname/path/to/file.json

# Create the app that would run
mkdir -p myapp
git clone https://github.com/yourusername/yourrepository

#list of commands to install dependencies
sudo yum install python
sudo yum install pip
pip install json
pip install elasticsearch

# Get the ingest and deployment script
wget -O myfile/auto-deployments.sh https://github.com/yourusername/yourrepository/raw/branchname/path/to/auto-deployments.sh
# Get the python ingest script
wget -O myfile/setup-env.sh https://github.com/yourusername/yourrepository/raw/branchname/path/to/setup-env.sh


EOF
}
