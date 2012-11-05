require 'marshal_socket/version'

require 'socket'

module MarshalSocket

  module Socket
    def dump(msg_type, obj)
      write_lock.synchronize do
        Marshal.dump([msg_type.to_sym, obj], self)
      end
    end

    def load
      read_lock.synchronize do
        Marshal.load(self)
      end
    end

    def bye
      write_lock.synchronize do
        Marshal.dump(:bye, self)
      end
    end

    def write_lock
      @write_lock = Mutex.new
    end

    def read_lock
      @read_lock = Mutex.new
    end

    def start(&block)
      Thread.new do
        run = true
        while run do
          obj = load
          if obj == :bye
            run = false
            close
          else
            block.call(obj)
          end
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
