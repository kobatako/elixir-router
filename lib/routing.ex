defmodule Routing do

    use Bitwise

    @doc """
    this is routing init 
    
    ## routing table
        - id
        - destination,      % destination ip address
        - routeMask,        % route net mask
        - nextHop,          % next hop ip address or connected
        - interface,        % interface
        - metric,           % destination metric
        - routeType,        % route type static or dynamic
        - sourceOfRoute,    % routing protocol
        - routeAge,         % route age count
        - routeInformation, % other route information
        - mtu               % MTU
    """
    def init() do
        :ets.new(:routing_table, [:set, :public, :named_table])
        :interface.get_interface()
        |> Enum.each(fn({name, interface}) -> :ets.insert_new(:routing_table,
            {name, {:netmask, Tuple.to_list(interface[:netmask])}, {:dest, Tuple.to_list(interface[:addr])}, {:nexthop, :connected},
            name, 0, "-", "link", 0, "-", 1500}) end)
    end

    @doc """
    this is fetch routing record
        - dest_ip : destination ip address
    """
    def fetch_routing_record(dest_ip) do
        search_routing_table(dest_ip)
        |> Enum.map(fn(record) -> select_nexthop_ip(record) end)
    end

    @doc """
    this is search routing table record
        - dest_ip : destination ip address
    """
    def search_routing_table(dest_ip) do
        IO.puts "routing search_routing_table"
        IO.inspect dest_ip

        # get ets routing route
        :ets.match(:routing_table, {:"_", :"$1", :"$2", :"$3", :"_", :"_", :"_", :"_", :"_", :"_", :"_"})

        # address -> {send ip, netmask, dest ip}
        # nexthop is dest ip to hop
        |> Enum.map(fn(record) -> [{:address, List.zip([dest_ip, record[:netmask], record[:dest]])}, {:nexthop, record[:nexthop]}] end)
        |> Enum.filter(fn(record) -> record[:addredd]
            |> Enum.all?(fn(octed) -> (elem(octed, 1) &&& elem(octed, 0) == (elem(octed, 1) &&& elem(octed, 2))) end)
        end)

        # match dest ip
        |> Enum.map(fn(record) -> [{:dest, (for octed <- record[:address] , do: elem(octed, 0))}, {:nexthop, record[:nexthop]}] end)
    end

    def select_nexthop_ip([{:dest, dest}, {:nexthop, :connected}]) do
        dest 
    end
    def select_nexthop_ip([{:dest, _}, {:nexthop, nexthop}]) do
       nexthop 
    end
end