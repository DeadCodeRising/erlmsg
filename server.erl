-module(server).
-export([start/0]).

start() -> spawn(fun init/0).

init() -> loop([]).

loop(Clients) ->
  process_flag(trap_exit, true),
  receive
    {From, connect, Username} ->
      link(From),
      broadcast(join, Clients, {Username}),
      loop([{Username, From} | Clients]);
    {From, send, Msg} ->
      broadcast(new_msg, Clients, {find(From, Clients), Msg}),
      loop(Clients);
    {'EXIT', From, _} ->
      broadcast(disconnect, Clients, {find(From, Clients)}),
      loop(Clients);
    _ ->
      loop(Clients)
  end.

broadcast(join, Clients, {Username}) ->
  broadcast({info, Username ++ " joined the chat."}, Clients);
broadcast(new_msg, Clients, {Username, Msg}) ->
  broadcast({new_msg, Username, Msg}, Clients);
broadcast(disconnect, Clients, {Username}) ->
  broadcast({info, Username ++ " left the chat."}, Clients).

broadcast(Msg, Clients) ->
  lists:foreach(fun({_, Pid}) -> Pid ! Msg end, Clients).

find(From, [{Username, Pid} | _]) when From == Pid ->
  Username;
find(From, [_ | T]) ->
  find(From, T).
