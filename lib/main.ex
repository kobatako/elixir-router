defmodule Main do
    @moduledoc """
    This is main module
    """

    @doc """
    This is initialization
    """
    def init() do
        IO.puts "main init"
        Arp.init()
        Routing.init()
    end

    @doc """
    This is start
    """
    def start({:ok, fd}) do
        init()
        loop(fd)
    end 

    @doc """
    This is loop process
    """
    def loop(fd) do
        #recive packet
        :libpacket.recvfrom(fd, 4096)
        |> Packet.recv

        loop(fd)
    end
end