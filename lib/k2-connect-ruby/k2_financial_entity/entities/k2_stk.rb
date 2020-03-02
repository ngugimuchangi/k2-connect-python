# For STK Push/Receive MPESA Payments from merchant's customers
class K2Stk < K2Entity

  # Receive payments from M-PESA users.
  def receive_mpesa_payments(params)
    params = params.with_indifferent_access
    # Validation
    params = validate_input(params, @exception_array += %w[payment_channel till_identifier first_name last_name phone email currency value metadata callback_url])
    # The Request Body Parameters
    k2_request_subscriber = {
      first_name: params[:first_name],
      last_name: params[:last_name],
      phone: validate_phone(params[:phone]),
      email: validate_email(params[:email])
    }
    k2_request_amount = {
      currency: params[:currency],
      value: params[:value]
    }
    k2_request_metadata = params[:metadata]
    k2_request_links = {
        call_back_url: params[:callback_url]
    }
    receive_body = {
      payment_channel: params[:payment_channel],
      till_identifier: params[:till_identifier],
      subscriber: k2_request_subscriber,
      amount: k2_request_amount,
      meta_data: k2_request_metadata,
      _links: k2_request_links
    }
    receive_hash = K2Stk.make_hash(K2Config.path_url('incoming_payments'), 'post', @access_token, 'STK', receive_body)
    @threads << Thread.new do
      sleep 0.25
      @location_url = K2Connect.make_request(receive_hash)
    end
    @threads.each(&:join)
  end

  # Query/Check STK Payment Request Status
  def query_status(path_url)
    super('STK', path_url)
  end

  # Query Location URL
  def query_resource_url(url)
    super('STK', url)
  end
end
