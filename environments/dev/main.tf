module "grafana_logs" {
  source               = "../../modules/grafana/logs"
  grafana_log_url      = var.grafana_log_url
  grafana_log_username = var.grafana_log_username
  grafana_log_key      = var.grafana_log_key
}

module "grafana_metrics" {
  source                      = "../../modules/grafana/metrics"
  grafana_metrics_endpoint    = var.grafana_metrics_endpoint
  grafana_metrics_instance_id = var.grafana_metrics_instance_id
  grafana_metrics_write_token = var.grafana_metrics_write_token
}