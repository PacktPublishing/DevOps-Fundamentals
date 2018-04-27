provider "google" {
  credentials = "${file("xxx.json")}"
  project     = "${var.project_name}"
  region      = "${var.default_region}"
}  
resource "google_compute_instance" "my-first-instance" {
  name = "my-first-instance"
  machine_type = "n1-standard-1"
  zone = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1704-zesty-v20170413"
    }
  }

  network_interface {
    network = "default"
    access_config {

     // Ephemeral IP
    }
  }
}

resource "google_compute_address" "my-first-ip" {
  name = "static-ip-address"
}
