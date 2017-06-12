require "async_play/version"

module AsyncPlay
  def self.opening
    q = QueueWithTimeout.new

    yield ->(result) { q.push result }

    q.pop
  end

  # It is an queue occurs error if there is no result within 1 second.
  # When results of asynchronous function can not be obtained,
  # make an error to prevent waiting indefinitely.
  # See https://spin.atomicobject.com/2014/07/07/ruby-queue-pop-timeout/
  class QueueWithTimeout
    def initialize
      @mutex = Mutex.new
      @queue = []
      @recieved = ConditionVariable.new
    end

    def push(x)
      @mutex.synchronize do
        @queue << x
        @recieved.signal
      end
    end

    def pop
      pop_with_timeout ENV['ASYNC_PLAY_WAIT_TIME']&.to_i || 1
    end

    private

    def pop_with_timeout(timeout)
      @mutex.synchronize do
        if @queue.empty?
          @recieved.wait(@mutex, timeout) if timeout != 0
          # if we're still empty after the timeout, raise exception
          raise ThreadError, "Results can not be obtained within #{timeout} second." if @queue.empty?
        end
        @queue.shift
      end
    end
  end
end
