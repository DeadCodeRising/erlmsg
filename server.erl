-module(server).
-export([start/0]).

start() -> spawn(fun init/0).

init() -> loop([]).

loop(Clients) ->
  receive
    {new_con, {Username, Pid}} ->
      io:format("*** NEW CONNECTION ***~n"),
      loop([{Username, Pid} | clients]);
    {send, Msg} ->
      io:format("*** SENDING MSG ***~n"),
      loop(clients);
    _ ->
      io:format("*** UNKNOWN CMD ***~n"),
      loop(clients)
  end.

  %send({Rec, Msg}, Clients) ->
%    io:format("*** UNKNOWN CMD ***~n")
%  end.
