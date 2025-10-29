locals {

  metrics = {
    loadbalancer = {
      sfn_template = "loadbalancer-metrics.tmpl.json"
    }
    server = {
      sfn_template = "server-metrics.tmpl.json"
    }
  }
}