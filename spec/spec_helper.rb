$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'faraday_middleware'
require 'faraday_middleware/aws_signers_v4'
require 'timecop'

def faraday(options = {})
  options = {
    url: 'https://apigateway.us-east-1.amazonaws.com'
  }.merge(options)

  stubs = Faraday::Adapter::Test::Stubs.new

  Faraday.new(options) do |faraday|
    faraday.request :aws_signers_v4,
      credentials: Aws::Credentials.new('akid', 'secret'),
      service_name: 'apigateway',
      region: 'us-east-1'

    faraday.response :json, :content_type => /\bjson$/

    faraday.adapter :test, stubs do |stub|
      yield(stub)
    end
  end
end