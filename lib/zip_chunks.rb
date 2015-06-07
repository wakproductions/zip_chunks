require 'zip'
require 'pathname'
require_relative 'file_manifest'

module ZipChunks
  class ZipChunks
    DVD_ZIP_MAX_SIZE = 4_675_000_000 # give a little room to insert the file manifest and other metadata files

    attr_accessor :manifest_file, :next_zip_file_id, :zip_file_size, :base_dir

    def initialize
      @manifest = FileManifest.new
      @next_zip_file_id = 1
      @zip_file_size = DVD_ZIP_MAX_SIZE
      Zip.default_compression = Zlib::BEST_COMPRESSION
    end

    def build_file_manifest(base_dir)
      @base_dir = base_dir
      @manifest.add_directory(base_dir)
      @manifest.save_manifest
    end

    # No test coverage
    def build_zips(output_dir, zip_filename_base)
      until @manifest.next_file_bunch(@zip_file_size).empty?
        build_zip(File.join(output_dir, "#{zip_filename_base}#{@next_zip_file_id}.zip"))
        @next_zip_file_id += 1
      end
    end

    # No test coverage
    def build_zip(zip_file_name)
      size_needed = @zip_file_size
      begin
        file_list = @manifest.next_file_bunch(size_needed)
        if file_list.size > 0
          filenames = file_list.map { |file_sym, data| file_sym.to_s }
          add_files_to_zip(zip_file_name, filenames)
          size_needed = size_needed - File.size(zip_file_name)
        end
      end while file_list.size > 0
    end

    # No test coverage
    def add_files_to_zip(zip_file_name, files_to_add)
      ::Zip::File.open(zip_file_name, ::Zip::File::CREATE) do |zip_io|
        files_to_add.each do |filename|
          zip_io.add(relative_path(@base_dir, filename.to_s), filename.to_s)
        end
      end
      update_manifest(files_to_add, zip_file_name)
    end

    # No test coverage
    def update_manifest(filenames, zip_file)
      filenames.each do |filename|
        @manifest[filename][:zip_file] = zip_file
      end
      save_manifest
    end


    # No test coverage
    def save_manifest
      @manifest.save_manifest(manifest_file || FileManifest::DEFAULT_SAVE_FILE)
    end

    def relative_path(base_path, absolute_file_path)
      base = Pathname.new(base_path)
      Pathname.new(absolute_file_path.to_s).relative_path_from(base).to_s
    end

  end
end