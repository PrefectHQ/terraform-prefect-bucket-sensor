output "eventgrid_system_topic_id" {
  value = try(azurerm_eventgrid_system_topic.this[0].id, null)
}

output "eventgrid_subscription_id" {
  value = azurerm_eventgrid_event_subscription.this.id
}

output "prefect_service_account_id" {
  value = try(prefect_service_account.this[0].id, null)
}

output "prefect_webhook" {
  value = prefect_webhook.this
}

output "prefect_webhook_id" {
  value = prefect_webhook.this.id
}

output "prefect_webhook_url" {
  value = prefect_webhook.this.endpoint
}
