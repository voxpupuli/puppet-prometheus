type Prometheus::Uri = Variant[
  Stdlib::Filesource,
  Stdlib::HTTPUrl,
  Stdlib::HTTPSUrl,
  Prometheus::S3Uri,
  Prometheus::GsUri,
]
