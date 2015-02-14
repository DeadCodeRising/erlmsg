-module(client).
-export([connect/2]).

connect(Username, Server) ->
  spawn(fun() -> start(Username, Server) end).

start(Username, Server) ->
  Server ! {self(), connect, Username},
  loop(Server, Username).

loop(Server, User) ->
  receive
    {send, Msg} ->
      Server ! {self(), send, Msg},
      loop(Server, User);
    {new_msg, From, Msg} ->
      io:format("[~s's client] - ~s: ~s~n", [User, From, Msg]),
      loop(Server, User);
    {info, Msg} ->
      io:format("[~s's client] - ~s~n", [User, Msg]),
      loop(Server, User);
    disconnect ->
        io:format("[~s's client] - Disconnected~n", [User]),
        exit(normal);
    _ ->
      io:format("[~s's client] - Error - Unknown command~n", [User]),
      loop(Server, User)
  end.
