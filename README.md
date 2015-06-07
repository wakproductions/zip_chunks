## Zip Chunks

The idea for this program spawned out of a very simple problem. I have hundreds of gigabytes of cherished photos and
videos what I want to back up from my computer hard drive. I want to compress them onto DVD-R's. The problem is that
a DVD only fits 4.7 GB worth of data. I want to split up all of my photo JPEG files among a collection of DVDs, but
also have a manifest file which lists the file name and the corresponding DVD/ZIP File.

This program will create ZIP archives of 4.7GB in size each and a separate file that pairs each compressed file
to the appropriate ZIP file for future reference.

### Things I'd Like To Fix

* Not happy with the way FileManifest converts the file paths to symbols to reference filenames. It
  seemed to make sense on the drawing board but in implementation is a little sloppy because you have to
  worry about the conversion to_sym a lot. Would like to fix this so that it becomes a cleaner wrapper
  around the filenames.
* Untested scenario: Need to handle problems if there is a single file that exceeds @zip_file_size
* Would like to write a feature spec for integration test