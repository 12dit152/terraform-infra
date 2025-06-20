variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

resource "aws_elasticache_subnet_group" "redis" {
  name        = "redis-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "Subnet group for Redis ElastiCache"
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "redis-repl-group"
  description                = "Redis replication group for upgrade compatibility"
  engine                     = "valkey"
  engine_version             = "8.0"
  parameter_group_name       = "default.valkey8"
  node_type                  = "cache.t4g.micro"
  num_node_groups            = 1
  port                       = 6379
  subnet_group_name          = aws_elasticache_subnet_group.redis.name
  security_group_ids         = var.security_group_ids
  automatic_failover_enabled = false
  apply_immediately          = true
  at_rest_encryption_enabled = false
  transit_encryption_enabled = false
  multi_az_enabled           = false
}

output "cache_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "cache_port" {
  value = aws_elasticache_replication_group.redis.port
}


