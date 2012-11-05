require 'marshal_socket/version'

require 'socket'

module MarshalSocket

  module Socket
    def dump(obj)
      write_lock.synchronize do
        Marshal.dump([:obj, obj], self)
      end
    end

    def load
      read_lock.synchronize do
        Marshal.load(self)
      end
    end

    def bye
      write_lock.synchronize do
        Marshal.dump([:bye], self)
      end
    end

    def write_lock
      @write_lock = Mutex.new
    end

    def read_lock
      @read_lock = Mutex.new
    end

    def receive_objects(&block)
      run = true

      while run do
        begin
          msg_type, obj = load
        rescue EOFError
          run = false
          next
        end

        case msg_type
        when :bye
          run = false
          close
        when :obj
          block.call(self, obj)
        else
          $stderr.puts "unknown message type #{msg_type.inspect}"
        end

      end

    end
  end

  class TCPServer < ::TCPServer
    def accept
      super.tap do |socket|
        socket.extend(Socket)
      end
    end
  end

  class TCPSocket < ::TCPSocket
    include Socket
  end

end
