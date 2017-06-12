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

    context 'environment variable ASYNC_PLAY_WAIT_TIME is set 3' do
      before do
        ENV['ASYNC_PLAY_WAIT_TIME'] = '3'
      end

      after do
        ENV['ASYNC_PLAY_WAIT_TIME'] = nil
      end

      it 'results can be obtained within 2 sec' do
        results = AsyncPlay.opening do | curtain |
           Thread.new do
             sleep 2
             curtain.call 1
           end
         end
        expect(results).to eq(1)
      end

      context 'results can not be obtained within 3 sec' do
        it "raises error" do
          expect{ AsyncPlay.opening { } }.to raise_error("Results can not be obtained within 3 second.")
        end
      end
    end
  end
end
