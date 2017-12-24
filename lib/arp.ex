defmodule Arp do
    @moduledoc """
    ARP module
    ## arp table
        - ip: ip address (key)
        - mac: mac address
        - timestamp: arp record time stamp
    """

    @doc """
    this si arp init
    """
    def init() do
        arp_table = :ets.new(:arp_table, [:set, :public, :named_table])
    end
end