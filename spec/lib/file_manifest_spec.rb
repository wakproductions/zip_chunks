require 'spec_helper'
require './lib/file_manifest'

RSpec.describe ZipChunks::FileManifest do
  let(:manifest) do
    ZipChunks::FileManifest.new
  end
  let(:file_path) { File.join(@file_fixtures_dir, 'Screen Shot 2015-01-24 at 8.43.11 PM.png') }
  let(:file_size) { 429_493 }
  let(:file_path_list) {
    ["file1.png", "file2.png", "file3,png", "file4.png"]
  }
  let(:fixtures_count) { 1_264 } # You may have to change this if you change the sample data in the file-fixtures folder

  describe '#add' do
    it 'accepts a single file as a String and attaches the file size' do
      manifest.add(file_path)
      expect(manifest[file_path.to_sym]).to be_a(Hash)
      expect(manifest[file_path.to_sym][:size]).to eql(file_size)
    end

    it 'accepts a list of files as an Array' do
      manifest.add(file_path_list)
      expect(manifest[file_path_list[2].to_sym]).to be_a(Hash)
    end
  end

  describe '#add_directory' do
    it 'adds all the files in the fixtures directory' do
      manifest.add_directory(@file_fixtures_dir)
      expect(manifest.manifest.size).to eql(fixtures_count)
    end
  end

  describe '#[](key)' do
    let(:metadata) { 'file description' }
    it 'sets an arbitrary file attribute' do
      manifest.add(file_path)
      manifest[file_path][:metadata] = metadata
      expect(manifest[file_path][:metadata]).to eql(metadata)
    end
  end

  describe '#next_file_bunch' do
    before(:each) { manifest.add_directory(@file_fixtures_dir) }
    let(:first_file) { File.join(@file_fixtures_dir, 'Screen Shot 2015-01-24 at 8.43.11 PM.png') }
    let(:total_size) { 25_000_000 }
    let(:one_GB) { 1_000_000_000 } # Encompassing a total size of 1GB should include all of the file-fixtures

    it "fetches a list of files less than 25MB" do
      file_list = manifest.next_file_bunch(total_size)
      file_list_size = file_list.inject(0) { |size, (file, data)| size + data[:size] }
      expect(file_list_size).to be < total_size
      expect(file_list_size).to be > 0
    end

    it "skips files that have already been assigned a zip file" do
      before_file_list = manifest.next_file_bunch(one_GB).to_h
      expect(before_file_list[first_file.to_sym]).to be_truthy # Check that it's there on this run

      manifest[first_file.to_sym][:zip_file] = "/Users/sjobs/zipfile.zip"
      after_file_list = manifest.next_file_bunch(one_GB).to_h
      expect(after_file_list[first_file.to_sym]).to be_nil # Check that it's not there on this run
      expect(after_file_list.keys.count).to eql(before_file_list.keys.count - 1) # should have exactly 1 less file this time
    end

  end


end