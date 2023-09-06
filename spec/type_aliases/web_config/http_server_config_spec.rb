# frozen_string_literal: true

require 'spec_helper'

describe 'Prometheus::Web_config::Http_server_config' do
  describe 'accepts minimal usage' do
    it { is_expected.to allow_value({}) }
  end

  describe 'accepts all paramters' do
    it {
      is_expected.to allow_value(
        {
          'http2' => true,
          'headers' => {
            'Content-Security-Policy' => 'default-src \'self\'',
            'X-Frame-Options' => 'SAMEORIGIN',
            'X-Content-Type-Options' => 'nosniff',
            'X-XSS-Protection' => '1; mode=block',
            'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains',
          }
        }
      )
    }
  end
end
