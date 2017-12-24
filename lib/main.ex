defmodule Main do
    def init() do
        IO.puts "main init"
        Arp.init()
        Routing.init()
    end
    def start({:ok, fd}) do
        init()
        loop(fd)
    end 
    def loop(fd) do
        #recive packet
        :libpacket.recvfrom(fd, 4096)
        |> Packet.recv

        loop(fd)
    end
end