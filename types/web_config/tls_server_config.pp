# @summary tls_server_config of a exporter webconfig
# @see https://github.com/prometheus/exporter-toolkit/blob/v0.10.0/docs/web-configuration.md
type Prometheus::Web_config::Tls_server_config = Struct[{
    cert_file => Stdlib::Absolutepath,
    key_file => Stdlib::Absolutepath,
    Optional[client_ca_file] => Stdlib::Absolutepath,
    Optional[client_auth_type] => String[1],
    Optional[client_allowed_sans] => Array[String[1],1],
    Optional[min_version] => String[1],
    Optional[max_version] => String[1],
    Optional[cipher_suites] => Array[String[1],1],
    Optional[prefer_server_cipher_suites] => Boolean,
    Optional[curve_preferences] => Array[String[1],1],
}]
