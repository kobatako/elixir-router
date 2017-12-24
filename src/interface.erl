-module(interface).
-export([get_interface/0]).

get_interface() ->
    {ok, IfLists} = inet:getifaddrs(),
    Listen = lists:filter(fun(Elm) -> interface_list(Elm) end, IfLists),
    Listen.

interface_list(Elm) ->
    {Name, _} = Elm,
    string:find(Name, "eth") =/= nomatch.

