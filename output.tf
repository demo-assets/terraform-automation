output "instance_external_ips" {
  value = google_compute_instance.workshop_vm.*.network_interface.0.access_config.0.nat_ip
  description = "The external IP addresses of the VM instances"
}
