# @summary webconfig for the exporter
# @see https://github.com/prometheus/exporter-toolkit/blob/v0.10.0/docs/web-configuration.md
type Prometheus::Web_config = Struct[{
    Optional[tls_server_config] => Prometheus::Web_config::Tls_server_config,
    Optional[http_server_config] => Prometheus::Web_config::Http_server_config,
    Optional[basic_auth_users] => Hash[String[1],String[1],1],
}]
