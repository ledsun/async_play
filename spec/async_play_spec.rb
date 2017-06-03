require "spec_helper"

RSpec.describe AsyncPlay do
  it "has a version number" do
    expect(AsyncPlay::VERSION).not_to be nil
  end

  describe "#opening" do
    it "obtains results of an asynchronous procedure" do
      results = AsyncPlay.opening{ | curtain | Thread.new { curtain.call 1 } }
      expect(results).to eq(1)
    end

    context 'results can not be obtained within 1 sec' do
      it "raises error" do
        expect{ AsyncPlay.opening { } }.to raise_error("Results can not be obtained within 1 second.")
      end
    end
  end
end
