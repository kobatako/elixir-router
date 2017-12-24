-module(libpacket).
-export([init/0]).
-export([parse_ethernet/1, parse_internet/1]).
-export([open/2, recvfrom/2]).

-define(TYPE_IPv4, 16#0800).
-define(TYPE_ARP, 16#0806).
-define(TYPE_AoE, 16#88A2).

init() ->
    io:format("hello ~n").

open(Port, Options) ->
    io:format("Port ~w~n", [Port]),
    io:format("Options ~w~n", [Options]),
    procket:open(Port, Options).

recvfrom(FD, Size) ->
    procket:recvfrom(FD, Size).

parse_ethernet(Buf) ->
    <<Dest:48, Source:48, Type:16, Data/bitstring>> = Buf,

    {binary_to_list(binary:encode_unsigned(Dest)),
    binary_to_list(binary:encode_unsigned(Source)),
    Type, Data}.

parse_internet({?TYPE_IPv4, Buf}) ->
    io:format("libpacket:parse_internet type ipv4~n"),
    <<Version:4, HeaderLen:4, Service:8, TotalLen:16,
        Identification:16, Flags:3, Fragment:13,
        Ttl:8, Protocol:8, Checksum:16,
        SourceAddress:32, DestAddress:32, Data/bitstring>> = Buf,

    #{version => Version, headerlen => HeaderLen, service => Service, totallen => TotalLen,
    identification => Identification, flags => Flags, fragment => Fragment,
    ttl => Ttl, protocol => Protocol, checksum => Checksum,
    sourceaddress => binary_to_list(binary:encode_unsigned(SourceAddress)),
    destaddress => binary_to_list(binary:encode_unsigned(DestAddress)),
    data => Data};

parse_internet({?TYPE_ARP, Buf}) ->
    io:format("libpacket:parse_internet type arp~n"),
    <<HardwareType:16, Protocol:16,
        AddressLen:8, ProtocolLen:8, OperationCode:16,
        SourceMacAddress:48, SourceIPAddress:32,
        DestMacAddress:48, DestIPAddress:32, Data/bitstring>> = Buf,

    {HardwareType, Protocol, AddressLen, ProtocolLen, OperationCode,
    binary_to_list(binary:encode_unsigned(SourceMacAddress)),
    binary_to_list(binary:encode_unsigned(SourceIPAddress)),
    binary_to_list(binary:encode_unsigned(DestMacAddress)),
    binary_to_list(binary:encode_unsigned(DestIPAddress)),
    Data}. 

