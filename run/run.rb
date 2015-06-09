require 'rubygems'
require_relative '../lib/zip_chunks'

# zip_chunks = ZipChunks::ZipChunks.new
# zip_chunks.zip_file_size = 25_000_000
# zip_chunks.build_file_manifest('/Users/wkotzan/Development/gem-development/zip-chunks/spec/file-fixtures')
# zip_chunks.save_manifest
#
# zip_chunks.build_zips('/Users/wkotzan/Development/gem-development/zip-chunks/output/', 'fixtures_')
#zip_chunks.build_zip('/Users/wkotzan/Development/gem-development/zip-chunks/output/fixtures.zip')

zip_chunks = ZipChunks::ZipChunks.new
#zip_chunks.zip_file_size = 4_625_000_000
zip_chunks.zip_file_size = 2_005_000_000
zip_chunks.build_file_manifest('/Users/wkotzan/Documents/backups/Photography')
zip_chunks.just_copy_files('/Users/wkotzan/Documents/backups/Photography-ZIPs', 'PhotographyBackup_20150609_')
