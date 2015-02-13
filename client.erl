-module(client).
-export([connect/2]).

connect(Username, Server) ->
  spawn(fun() -> start(Username, Server) end).

start(Username, Server) ->
  Server ! {connect, {Username, self()}},
  loop(Server).

loop(Server) ->
  receive
    {send, {Rec, Msg}} ->
      Server ! {send, {self(), Rec, Msg}},
      loop(Server);
    {new_msg, Msg} ->
      io:format("~p: New msg: ~s~n", [self(), Msg]),
      loop(Server);
    {ack, Rec} ->
      io:format("~p: Msg to ~s is delivered~n", [self(), Rec]),
      loop(Server);
    {err, Msg} ->
      io:format("~p: Error - ~s~n", [self(), Msg]),
      loop(Server);
    _ ->
      io:format("~p: Error - Unknown command~n", [self()]),
      loop(Server)
  end.
