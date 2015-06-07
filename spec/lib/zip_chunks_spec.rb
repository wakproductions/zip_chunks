require 'spec_helper'
require './lib/zip_chunks'

RSpec.describe ZipChunks::ZipChunks do
  subject { ZipChunks::ZipChunks.new }
  describe '#relative_path' do
    let(:base) { '/Users/sjobs/Documents' }
    let(:absolute) { '/Users/sjobs/Documents/ipod/specifications.docx' }

    it 'converts an absolute file path to a relative path' do
      expect(subject.relative_path(base, absolute)).to eql('ipod/specifications.docx')
    end

  end

end