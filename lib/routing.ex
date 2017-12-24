defmodule Routing do

    @doc """
    this is routing init 
    """
    def init() do
        routing_table = :ets.new(:routing_table, [:set, :public, :named_table])
    end

    @doc """
    this is search routing table record
    """
    def search_routing_table(dest_ip) do
        dest_ip
    end
end