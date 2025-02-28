# frozen_string_literal: true

require_relative '../../lib/deadfinder/logger'
require 'stringio'

RSpec.describe Logger do
  before do
    @original_stdout = $stdout
    $stdout = StringIO.new
  end

  after do
    $stdout = @original_stdout
  end

  def strip_ansi_codes(str)
    str.gsub(/\e\[[0-9;]*m/, '')
  end

  describe '.silent?' do
    it 'returns false by default' do
      expect(described_class.silent?).to be false
    end
  end

  describe '.set_silent' do
    it 'sets the silent mode to true' do
      described_class.set_silent
      expect(described_class.silent?).to be true
    end
  end

  describe '.unset_silent' do
    it 'sets the silent mode to false' do
      described_class.set_silent
      described_class.unset_silent
      expect(described_class.silent?).to be false
    end
  end

  describe '.info' do
    it 'prints info message when not in silent mode' do
      described_class.info('Test info')
      expect(strip_ansi_codes($stdout.string)).to include('ℹ Test info')
    end

    it 'does not print info message when in silent mode' do
      described_class.set_silent
      described_class.info('Test info')
      expect($stdout.string).to be_empty
    end
  end

  describe '.error' do
    it 'prints error message when not in silent mode' do
      described_class.unset_silent
      described_class.error('Test error')
      expect(strip_ansi_codes($stdout.string)).to include('⚠︎ Test error')
    end

    it 'does not print error message when in silent mode' do
      described_class.set_silent
      described_class.error('Test error')
      expect($stdout.string).to be_empty
    end
  end

  describe '.target' do
    it 'prints target message when not in silent mode' do
      described_class.unset_silent
      described_class.target('Test target')
      expect(strip_ansi_codes($stdout.string)).to include('► Test target')
    end

    it 'does not print target message when in silent mode' do
      described_class.set_silent
      described_class.target('Test target')
      expect($stdout.string).to be_empty
    end
  end

  describe '.sub_info' do
    it 'prints sub_info message when not in silent mode' do
      described_class.unset_silent
      described_class.sub_info('Test sub_info')
      expect(strip_ansi_codes($stdout.string)).to include('  ● Test sub_info')
    end

    it 'does not print sub_info message when in silent mode' do
      described_class.set_silent
      described_class.sub_info('Test sub_info')
      expect($stdout.string).to be_empty
    end
  end

  describe '.sub_done' do
    it 'prints sub_done message when not in silent mode' do
      described_class.unset_silent
      described_class.sub_done('Test sub_done')
      expect(strip_ansi_codes($stdout.string)).to include('  ✓ Test sub_done')
    end

    it 'does not print sub_done message when in silent mode' do
      described_class.set_silent
      described_class.sub_done('Test sub_done')
      expect($stdout.string).to be_empty
    end
  end
end
