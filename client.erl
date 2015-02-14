-module(client).
-export([connect/2]).

connect(Username, Server) ->
  spawn(fun() -> start(Username, Server) end).

start(Username, Server) ->
  Server ! {self(), connect, Username},
  loop(Server).

loop(Server) ->
  receive
    {send, Msg} ->
      Server ! {self(), send, Msg},
      loop(Server);
    {new_msg, From, Msg} ->
      io:format("~p: ~s: ~s~n", [self(), From, Msg]),
      loop(Server);
    {info, Msg} ->
      io:format("~p: ~s~n", [self(), Msg]),
      loop(Server);
    {disconnect} ->
        io:format("~p: Disconnected~n", [self()]),
        exit(normal);
    _ ->
      io:format("~p: Error - Unknown command~n", [self()]),
      loop(Server)
  end.
