require 'rubygems'
require_relative '../lib/zip_chunks'

zip_chunks = ZipChunks::ZipChunks.new
zip_chunks.zip_file_size = 25_000_000
zip_chunks.build_file_manifest('/Users/wkotzan/Development/gem-development/zip-chunks/spec/file-fixtures')
zip_chunks.save_manifest

zip_chunks.build_zips('/Users/wkotzan/Development/gem-development/zip-chunks/output/', 'fixtures_')
#zip_chunks.build_zip('/Users/wkotzan/Development/gem-development/zip-chunks/output/fixtures.zip')
