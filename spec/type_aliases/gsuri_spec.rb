# frozen_string_literal: true

require 'spec_helper'

describe 'Prometheus::GsUri' do
  describe 'accepts case-sensitive google cloud services gs uris' do
    [
      'gs://bucket-name/path',
      'gs://bucket/path/to/file.txt'
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'rejects other values' do
    [
      '',
      'GS://bucket-name/path',
      3,
      'gs:/bucket-name/path',
      'gs//bucket-name/path',
      'gs:bucket-name/path',
      'gs-bucket-name/path'
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
