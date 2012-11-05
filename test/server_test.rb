require_relative 'helper'

describe MarshalSocket::TCPServer do
  before do
    @server  = MarshalSocket::TCPServer.new(0)
    _, @port = @server.addr
  end

  describe '#accept' do
    it 'returns sockets with the MarshalSocket::Socket modules mixed in' do
      client_thread = Thread.new do
        client = MarshalSocket::TCPSocket.new('localhost', @port)
      end

      socket = @server.accept

      assert socket.respond_to?(:dump)
      assert socket.respond_to?(:load)
    end
  end

  it 'should work' do
    received = []

    client_thread = Thread.new do
      client = MarshalSocket::TCPSocket.new('localhost', @port)

      client.dump(1)
      client.dump('string')
      client.dump(:symbol)
      client.dump(true)
      client.dump(['array'])
      client.dump(:hash => true)

      client.bye

      client.receive_objects do |sock, obj|
        received << obj
      end
    end

    server_socket = @server.accept
    server_thread = Thread.new do
      server_socket.receive_objects do |sock, obj|
        sock.dump(obj)
      end
    end

    client_thread.join
    server_thread.join

    received.size.must_equal 6
    received[0].must_equal 1
    received[1].must_equal 'string'
    received[2].must_equal :symbol
    received[3].must_equal true
    received[4].must_equal ['array']
    received[5].must_equal({:hash => true})
  end
end
