-module(server).
-export([start/0]).
-export([prn/1]).

start() -> spawn(fun init/0).

init() -> loop([]).

loop(Clients) ->
  receive
    {new_con, {Username, Pid}} ->
      io:format("*** NEW CONNECTION ***~n"),
      loop([{Username, Pid} | Clients]);
    {send, {Rec, Msg}} ->
      io:format("*** SENDING MSG ***~n"),
      send(Msg, findReceiver(Rec, Clients)),
      loop(Clients);
    {prn} ->
      prn(Clients);
    _ ->
      io:format("*** UNKNOWN CMD ***~n"),
      loop(Clients)
  end.

prn([{Username, Pid} | T]) ->
  io:format("- " ++ Username ++ "@" ++ Pid ++ "~n"),
  prn(T);
prn([]) ->
  ok.


send(Msg, [{Rec, Pid}]) ->
  io:format("Sending to " ++ Rec ++ "@" ++ Pid ++ "~n"),
  io:format(Msg ++ "~n");
send(_, []) ->
  io:format("Couldn't find the receiver").

findReceiver(Rec, Clients) ->
  lists:filter(fun(C) -> getUsername(C) == Rec end, Clients).

getUsername({Username, _}) ->
  Username.
