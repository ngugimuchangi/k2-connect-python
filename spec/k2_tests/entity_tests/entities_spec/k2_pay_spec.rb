include K2Validation
RSpec.describe K2Pay do
  before(:all) do
    # K2Pay object
    @k2pay = K2Pay.new(K2AccessToken.new('KkcZEdj7qx7qfcFMyTWFaUXV7xZv8z8WIm72U06BiPI', 'mVoTlmrjsMw2mnfTXQrynz49ZcDX05Xp5wty-uNaZX8').request_token)

    @create_request_body = {  destination: "3344-effefnkka-132", currency: "KES", value: 20000, callback_url: "https://webhook.site/437a5819-1a9d-4e96-b403-a6f898e5bed3", metadata: { customerId: '8_675_309', notes: 'Salary payment for May 2018' } }
    @mobile_pay_request_body = { type: "mobile_wallet", first_name: "John", last_name: "Doe", email: "johndoe@nomail.net", phone: "+254716230902", network: "Safaricom" }
    @bank_pay_request_body = { type: "bank_account", first_name: "John", last_name: "Doe", email: "johndoe@nomail.net", phone: "+254716230902", account_name: "David Kariuki", account_number: 566566, bank_id: 21, bank_branch_id: 2133 }
  end

  describe '#pay_recipients' do
    it 'should add mobile wallet pay recipient request' do
      SpecStubRequest.stub_request('post', K2Config.path_url('pay_recipient'), @mobile_pay_request_body, 201)
      @k2pay.pay_recipients(@mobile_pay_request_body)
      expect(@k2pay.recipients_location_url).not_to eq(nil)
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('pay_recipient')))
    end

    it 'should add bank account pay recipient request' do
      SpecStubRequest.stub_request('post', K2Config.path_url('pay_recipient'), @bank_pay_request_body, 201)
      @k2pay.pay_recipients(@bank_pay_request_body)
      expect(@k2pay.recipients_location_url).not_to eq(nil)
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('pay_recipient')))
    end
  end

  describe '#create_payment' do
    it 'should create outgoing payment request' do
      SpecStubRequest.stub_request('post', K2Config.path_url('payments'), @create_request_body, 201)
      @k2pay.create_payment(@create_request_body)
      expect(@k2pay.payments_location_url).not_to eq(nil)
      expect(WebMock).to have_requested(:post, URI.parse(K2Config.path_url('payments')))
    end
  end

  describe '#query_pay' do
    it 'should query adding pay recipients' do
      SpecStubRequest.stub_request('get', @k2pay.recipients_location_url, '', 200)
      expect { @k2pay.query_status(@k2pay.recipients_location_url) }.not_to raise_error
      expect(@k2pay.k2_response_body).not_to eq(nil)
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2pay.recipients_location_url)))
    end

    it 'should query creating payment request status' do
      SpecStubRequest.stub_request('get', @k2pay.payments_location_url, @create_request_body, 200)
      expect { @k2pay.query_status(@k2pay.payments_location_url) }.not_to raise_error
      expect(@k2pay.k2_response_body).not_to eq(nil)
      expect(WebMock).to have_requested(:get, K2UrlParse.remove_localhost(URI.parse(@k2pay.payments_location_url)))
    end
  end
end
