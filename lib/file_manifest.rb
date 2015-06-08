module ZipChunks
  class FileManifest
    EXCLUDE_FILTER = ['.', '..', 'desktop.ini', '.DS_Store'] # Think about changing this later to a setting that can be changed via YAML and including Regex
    DEFAULT_SAVE_FILE=File.join(Dir.pwd, 'output', 'file_manifest.csv')
    attr_accessor :manifest

    def initialize
      @manifest = Hash.new  # to be k/v pair of 'filename'/{:zip_file=>"<zip filename>", :size=>"<file size>", ...}
    end

    def add(file_names)
      if file_names.is_a? Array
        file_names.each { |file| add_file(file) if file.is_a?(String) || file.is_a?(Symbol) }
      elsif file_names.is_a?(String) || file.is_a?(Symbol)
        add_file(file_names)
      end
    end

    def add_directory(dir)
      add(list_dir_files_recursively(dir))
    end

    def [](key)
      @manifest[key.to_sym]
    end

    def next_file_bunch(max_size)
      bunch_size = 0

      # Filters out the ones that have a zip file attached
      @manifest.reject { |file, data| data[:zip_file] }.take_while do |file, data|
        if bunch_size + data[:size] <= max_size
          bunch_size += data[:size]
          true
        else
          false
        end
      end
    end

    def files_in_zip(zip_file)
      @manifest.select { |file, data| data[:zip_file].eql?(zip_file) }
    end

    # No test coverage for this
    def save_manifest(filename=DEFAULT_SAVE_FILE)
      f = open(filename, 'w')
      begin
        f.write "Filename|Size|ZIP File\n"
        @manifest.each do |filename, data|
          f.write "#{filename.to_s}|#{data[:size]}|#{data[:zip_file]}\n"
        end
      ensure
        f.close
      end
    end

    def load_manifest_file(filename)
      f = open(filename, 'r')
      f.readline  # skip the header
      until f.eof?
        file,size,zip_file = f.readline.strip.split('|')

        # This will only UPDATE an existing manifest object - so that you don't have references to files that no longer
        # exist if the manifest is old.
        if @manifest[file.to_sym]
          unless size==''
            @manifest[file.to_sym][:size] = size.to_i
          end

          unless zip_file==''
            @manifest[file.to_sym][:zip_file] = zip_file
          end
        end
      end
    end

    private

    def add_file(file_name)
      unless @manifest[file_name.to_sym]
        @manifest[file_name.to_sym] = Hash.new # Initialize the value to a hash, otherwise leave the data alone
        attach_file_size(file_name)
      end
    end

    def attach_file_size(file)
      size = File.size?(file.to_s) || 0
      @manifest[file.to_sym][:size] = size
    end

    def list_dir_files_recursively(dir)
      entries = Dir.entries(dir).sort { |a,b| a <=> b }
      entries = entries - EXCLUDE_FILTER

      files = entries.select { |e| File.file? File.join(dir, e) }
      directories = entries.select { |e| File.directory? File.join(dir, e) }

      list = Array.new
      files.each { |file| list << File.join(dir, file) }
      directories.each { |directory| list = list + list_dir_files_recursively(File.join(dir, directory)) }
      list
    end
  end
end