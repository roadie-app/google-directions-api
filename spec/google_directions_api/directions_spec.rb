require 'spec_helper'

describe GoogleDirectionsAPI::Directions do
  let(:ga_state_house) { '33.7487,-84.3876' }
  let(:sc_state_house) { '33.999729,-81.032936' }

  subject do
    VCR.use_cassette 'getting directions' do
      GoogleDirectionsAPI::Directions.new_for_locations(from: ga_state_house, to: sc_state_house).tap do |d|
        d.distance
      end
    end
  end

  describe '.new_for_location' do
    it 'returns an instance of directions' do
      expect(subject).to be_a(GoogleDirectionsAPI::Directions)
    end
  end

  describe '#distance' do
    it 'returns distance in miles' do
      expect(subject.distance).to eq(214.372995)
    end
  end

  describe '#duration' do
    it 'returns the time in minutes' do
      expect(subject.duration).to eq(185)
    end
  end

  describe '#polyline' do
    it 'returns a polyline for the whole trip' do
      expect(subject.polyline).to match /^ip.+/
    end
  end

  describe 'directions not found' do
    it 'throws an error if directions are not found' do
      bad_directions = described_class.new_for_locations(from: "0,0", to: "0,0")
      VCR.use_cassette 'bad directions' do
        expect{bad_directions.duration}.to raise_error
      end
    end
  end
end
