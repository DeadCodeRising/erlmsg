-module(server).
-export([start/0]).

start() -> spawn(fun init/0).

init() -> loop([]).

loop(Clients) ->
  receive
    {connect, {Username, Pid}} ->
      loop([{Username, Pid} | Clients]);
    {send, {From, Rec, Msg}} ->
      send(From, Msg, findReceiver(Rec, Clients)),
      loop(Clients);
    _ ->
      io:format("Server: Unknown cmd~n"),
      loop(Clients)
  end.

send(From, Msg, [{Username, Pid}]) ->
  Pid ! {new_msg, Msg},
  From ! {ack, Username};
send(From, _, []) ->
  From ! {err, "Couldn't find the receiver"}.

findReceiver(Rec, Clients) ->
  lists:filter(fun(C) -> getUsername(C) == Rec end, Clients).

getUsername({Username, _}) -> Username.
