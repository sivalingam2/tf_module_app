data "dns_a_record_set" "private_alb_name" {
  host = var.private_alb_name
}