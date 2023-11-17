# frozen_string_literal: true

require 'spec_helper'

describe 'Prometheus::Web_config::Tls_server_config' do
  describe 'accepts minimal usage' do
    it {
      is_expected.to allow_value(
        {
          'cert_file' => '/etc/pki/tls/certs/example.com.pem',
          'key_file' => '/etc/pki/tls/private/example.com.pem',
        }
      )
    }
  end

  describe 'accepts all paramters' do
    it {
      is_expected.to allow_value(
        {
          'cert_file' => '/etc/pki/tls/certs/example.com.pem',
          'key_file' => '/etc/pki/tls/private/example.com.pem',
          'client_ca_file' => '/etc/pki/tls/cert.pem',
          'client_auth_type' => 'NoClientCert',
          'client_allowed_sans' => [
            'client.example.com'
          ],
          'min_version' => 'TLS12',
          'max_version' => 'TLS13',
          'cipher_suites' => %w[
            TLS_CHACHA20_POLY1305_SHA256
            TLS_AES_256_GCM_SHA384
            TLS_AES_128_GCM_SHA256
          ],
          'prefer_server_cipher_suites' => true,
          'curve_preferences' => [
            'X25519'
          ]
        }
      )
    }
  end
end
