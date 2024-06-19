resource "kubernetes_daemonset" "cloudwatch_agent" {
  metadata {
    name      = "cloudwatch-agent"
    namespace = "kube-system"
  }

  spec {
    selector {
      match_labels = {
        name = "cloudwatch-agent"
      }
    }

    template {
      metadata {
        labels = {
          name = "cloudwatch-agent"
        }
      }

      spec {
        service_account_name = "cloudwatch-agent"
        containers {
          name  = "cloudwatch-agent"
          image = "amazon/cloudwatch-agent:latest"

          resources {
            limits {
              cpu    = "200m"
              memory = "200Mi"
            }
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }

          volume_mounts {
            name       = "config-volume"
            mount_path = "/etc/cloudwatch-agent/config.json"
            sub_path   = "config.json"
            read_only  = true
          }
        }

        volumes {
          name = "config-volume"
          config_map {
            name = "cloudwatch-agent-config"
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "cloudwatch_agent_config" {
  metadata {
    name      = "cloudwatch-agent-config"
    namespace = "kube-system"
  }

  data = {
    "config.json" = <<-EOF
    {
      "agent": {
        "metrics_collection_interval": 60,
        "run_as_user": 0
      },
      "metrics": {
        "namespace": "EKS/Pods",
        "append_dimensions": {
          "ClusterName": "${aws_eks_cluster.nexasphere-eks.name}"
        },
        "aggregation_dimensions": [["InstanceId", "InstanceType"], ["AutoScalingGroupName"], []],
        "metrics_collected": {
          "cpu": {
            "measurement": ["cpu_usage_idle", "cpu_usage_iowait", "cpu_usage_user", "cpu_usage_system"],
            "metrics_collection_interval": 60,
            "resources": ["*"]
          },
          "mem": {
            "measurement": ["mem_used_percent"],
            "metrics_collection_interval": 60,
            "resources": ["*"]
          },
          "net": {
            "measurement": ["net_packets_in", "net_packets_out"],
            "metrics_collection_interval": 60,
            "resources": ["*"]
          }
        }
      }
    }
    EOF
  }
}

resource "kubernetes_daemonset" "cloudwatch_logs" {
  metadata {
    name      = "cloudwatch-logs"
    namespace = "kube-system"
  }

  spec {
    selector {
      match_labels = {
        name = "cloudwatch-logs"
      }
    }

    template {
      metadata {
        labels = {
          name = "cloudwatch-logs"
        }
      }

      spec {
        service_account_name = "cloudwatch-logs"
        containers {
          name  = "cloudwatch-logs"
          image = "amazon/cloudwatch-agent:latest"

          resources {
            limits {
              cpu    = "200m"
              memory = "200Mi"
            }
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }

          volume_mounts {
            name       = "config-volume"
            mount_path = "/etc/cloudwatch-agent/config.json"
            sub_path   = "config.json"
            read_only  = true
          }
        }

        volumes {
          name = "config-volume"
          config_map {
            name = "cloudwatch-logs-config"
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "cloudwatch_logs_config" {
  metadata {
    name      = "cloudwatch-logs-config"
    namespace = "kube-system"
  }

  data = {
    "config.json" = <<-EOF
    {
      "logs": {
        "logs_collected": {
          "kubernetes": {
            "cluster_name": "${aws_eks_cluster.nexasphere-eks.name}",
            "types": [
              {
                "type": "container_insights",
                "log_group_name": "/aws/containerinsights/${aws_eks_cluster.nexasphere-eks.name}/application"
              }
            ]
          }
        },
        "log_stream_name": "{instance_id}"
      }
    }
    EOF
  }
}