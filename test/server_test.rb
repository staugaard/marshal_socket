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
end
