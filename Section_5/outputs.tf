output "instance_ip" {
    value = "${google_compute_instance.my-first-instance.network_interface.0.access_config.0.nat_ip}"
}

output "instance_zone" {
    value = "The zone is ${google_compute_instance.my-first-instance.zone}"
}