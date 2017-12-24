defmodule Packet do

    @type_ipv4 0x0800
    @type_arp 0x0806
    @type_aoe 0x88A2

    def recv({:error, _}) do
    end

    def recv({:ok, buf}) do
        IO.inspect buf
        spawn fn -> parse buf end
    end

    def parse(buf) do
        IO.inspect buf
        buf
        |> ethernet
        |> :libpacket.parse_internet
    end

    def ethernet(buf) do
        buf
        |> :libpacket.parse_ethernet
        |> proc_ethernet
    end

    def proc_ethernet({dest, source, type, data}) do
        if dest_local_address?(dest) do
            {type, data}
            |> :libpacket.parse_internet
            |> proc_internet(type, dest, source)
        end
    end

    @doc """
    This is the dest local address
    """
    def dest_local_address?(dest) do
        :interface.get_interface()
        |> Enum.any?(fn(interface) -> elem(interface, 1)[:hwaddr] == dest end)
    end

    def proc_internet(data, @type_ipv4, dest, _) do
        IO.puts "proc_internet type ipv4"
        IO.inspect data
        IO.inspect Enum.join(dest)
        Routing.fetch_routing_record(data[:destaddress])
        |> def_ip
    end

    def proc_internet(data, @type_arp, dest, source) do
        IO.puts "proc_internet type arp"
        IO.inspect data
        IO.inspect dest
        IO.inspect source
    end

    def proc_internet(data, @type_aoe, _, _) do
        IO.puts "proc_internet type aoe"
        IO.inspect data
    end

    def def_ip([]) do
        []
    end
    def def_ip(dest) do 
        dest
        |> Enum.map(fn(record) -> :ets.lookup(:arp_table, Enum.join(record)) end)
        |> dest_mac_address
    end

    @doc """
    This is not match arp table record
    """
    def dest_mac_address([]) do
        IO.puts "dest ip []"
        broadcast_arp_request()
    end

    @doc """
    this is match arp record
    """
    def dest_mac_address([{obj}]) do
        IO.puts "dest ip [{obj}]"
        IO.inspect obj
    end

    def broadcast_arp_request() do
        IO.puts "broadcast arp request"
    end
end