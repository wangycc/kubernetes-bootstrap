output "all zones" {
  description = "List all zones" 
  value       = ["${data.alicloud_zones.az.*.id}"]
}
