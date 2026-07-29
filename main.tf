terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "6.37.0"
        }
    }
    required_version = "~> 1.5.7"
}

provider "google" {
    project = "my-project-1531162999295"
    region = "us-central1"
}

resource "google_compute_region_instance_template" "claude_code_template" {
    name = "claude-code-vm"
    disk {
        source_image = "family/debian-12"
        # POTENTIAL BUG
        # I think `boot = true` is necessary, but I'm not sure
        boot = true
    }

    network_interface {
        network = "default"
    }

    machine_type = "e2-medium"

    metadata = {
        "startup-script" = file("init_claude_code_vm.sh")
    }

# 1. Explicitly strip the default service account (Thanks Google AI mode)
  service_account {
    # Leaving the email and scopes empty tells GCP 
    # to attach nothing to the instance.
    email  = null
    scopes = []
  }
}
