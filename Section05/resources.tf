// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.project_name}"
  region      = "${var.default_region}"
}  

resource "google_compute_instance" "my-first-instance" {
  name         = "my-first-instance"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"
  disk {
    image = "ubuntu-os-cloud/ubuntu-1704-zesty-v20170413"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.my-first-ip.address}"
    } 
  }
}

resource "google_compute_address" "my-first-ip" {
  name = "static-ip-address"
}
