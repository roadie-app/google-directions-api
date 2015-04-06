require 'spec_helper'

describe GoogleDirectionsAPI do
  it 'has a version number' do
    expect(GoogleDirectionsAPI::VERSION).not_to be nil
  end

  describe '#configure' do
    let(:logger){ double(:logger) }

    before do
      described_class.configure do |c|
        c.logger = logger
      end
    end

    it 'sets the logger' do
      expect(described_class.configuration.logger).to eq(logger)
    end
  end
end
