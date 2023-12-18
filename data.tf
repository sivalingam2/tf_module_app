data "dns_a_record_set" "private_alb" {
  host = var.private_alb_name
}