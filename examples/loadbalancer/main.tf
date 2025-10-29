module "loadbalancer_metrics" {
  source = "../.."

  hetzner_cloud_api_token = "api_token_value"
  metric_type             = "loadbalancer"
  data = {
    loadbalancer_id = "123456"
  }
}