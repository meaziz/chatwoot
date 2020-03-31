class AsyncDispatcher < BaseDispatcher
  def dispatch(event_name, timestamp, data)
    EventDispatcherJob.perform_later(event_name, timestamp, data)
  end

  def publish_event(event_name, timestamp, data)
    event_object = Events::Base.new(event_name, timestamp, data)
    publish(event_object.method_name, event_object)
  end

  def listeners
    listeners = [AgentBotListener.instance, EmailNotificationListener.instance, ReportingListener.instance, WebhookListener.instance]
    listeners << EventListener.instance
    listeners << SubscriptionListener.instance if ENV['BILLING_ENABLED']
    listeners
  end
end
