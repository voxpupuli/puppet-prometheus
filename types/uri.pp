# @summary A URI that can be used to fetch a Prometheus configuration file
type Prometheus::Uri = Variant[
  Stdlib::Filesource,
  Stdlib::HTTPUrl,
  Stdlib::HTTPSUrl,
  Prometheus::S3Uri,
  Prometheus::GsUri,
]
