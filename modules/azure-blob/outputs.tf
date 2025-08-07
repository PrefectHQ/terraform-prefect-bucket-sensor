output "eventgrid_system_topic_id" {
  value = one(azurerm_eventgrid_system_topic.this[0].id)
}

output "eventgrid_subscription_id" {
  value = azurerm_eventgrid_event_subscription.this.id
}

output "prefect_service_account_id" {
  value = one(prefect_service_account.this[0].id)
}

output "prefect_webhook_id" {
  value = prefect_webhook.this.id
}
