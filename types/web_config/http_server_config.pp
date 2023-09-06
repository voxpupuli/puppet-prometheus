# @summary http_server_config of a exporter webconfig
# @see https://github.com/prometheus/exporter-toolkit/blob/v0.10.0/docs/web-configuration.md
type Prometheus::Web_config::Http_server_config = Struct[{
    Optional[http2] => Boolean,
    Optional[headers] => Struct[{
        Optional['Content-Security-Policy'] => String[1],
        Optional['X-Frame-Options'] => String[1],
        Optional['X-Content-Type-Options'] => String[1],
        Optional['X-XSS-Protection'] => String[1],
        Optional['Strict-Transport-Security'] => String[1],
    }]
}]
