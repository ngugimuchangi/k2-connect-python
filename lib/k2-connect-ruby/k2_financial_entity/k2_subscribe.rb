# Class for Subscription Service
class K2Subscribe
  attr_reader :event_type, :location_url, :k2_response_body
  attr_accessor :access_token

  # Intialize with the event_type
  def initialize(access_token)
    raise ArgumentError, 'Nil or Empty Access Token Given!' if access_token.blank?
    @access_token = access_token
  end

  # Implemented a Case condition that minimises repetition
  def webhook_subscribe(webhook_secret = @webhook_secret, event_type, callback_url)
    raise ArgumentError, 'Nil or Empty Event Type Specified!' if event_type.blank?
    raise ArgumentError, 'Nil or Empty Webhook Specified!' if webhook_secret.blank?
    @webhook_secret = webhook_secret
    case event_type
      # Buygoods Received
    when 'buygoods_transaction_received'
      k2_request_body = {
        event_type: 'buygoods_transaction_received',
        url: callback_url,
        secret: @webhook_secret,
        scope: 'Till',
        scope_reference: '5555'
      }

      # Buygoods Reversed
    when 'buygoods_transaction_reversed'
      k2_request_body = {
        event_type: 'buygoods_transaction_reversed',
        url: callback_url,
        secret: @webhook_secret,
        scope: 'Till',
        scope_reference: '5555'
      }

      # Customer Created.
    when 'customer_created'
      k2_request_body = {
        event_type: 'customer_created',
        url: callback_url,
        secret: @webhook_secret,
        scope: 'Till',
        scope_reference: '5555'
      }

      # Settlement Transfer Completed
    when 'settlement_transfer_completed'
      k2_request_body = {
        event_type: 'settlement_transfer_completed',
        url: callback_url,
        secret: @webhook_secret,
        scope: 'Till',
        scope_reference: '5555'
      }

      # External Till to Till Transfer Completed
    when 'b2b_transaction_received'
      k2_request_body = {
        event_type: 'b2b_transaction_received',
        url: callback_url,
        secret: @webhook_secret,
        scope: 'Till',
        scope_reference: '5555'
      }

      # Merchant to Merchant Transaction
    when 'm2m_transaction_received'
      k2_request_body = {
        event_type: 'm2m_transaction_received',
        url: callback_url,
        secret: @webhook_secret,
        scope: 'Till',
        scope_reference: '5555'
      }
    else
      raise ArgumentError, 'Subscription Service does not Exist!'
    end
    @event_type = event_type
    subscribe_hash = K2Subscribe.make_hash(K2Config.path_url('webhook_subscriptions'), 'post', @access_token,'Subscription', k2_request_body)
    @location_url =  K2Connect.make_request(subscribe_hash)


  end

  # Query Recent Webhook
  def query_webhook
    query_hash = K2Pay.make_hash(@location_url, 'get', @access_token, 'Subscription', nil)
    @k2_response_body = K2Connect.make_request(query_hash)
  end

  # Query Specific Webhook URL
  def query_resource_url(url)
    query_hash = K2Pay.make_hash(url, 'get', @access_token, 'Subscription', nil)
    @k2_response_body = K2Connect.make_request(query_hash)
  end

  # Method for Validating the input itself
  def validate_input(id, secret)
    raise ArgumentError, 'Empty Client Credentials' if id.blank? || secret.blank?
  end

  # Create a Hash containing important details accessible for K2Connect
  def self.make_hash(path_url, request, access_token, class_type, body)
    {
      path_url: path_url,
      access_token: access_token,
      request_type: request,
      class_type: class_type,
      params: body
    }.with_indifferent_access
  end
end
