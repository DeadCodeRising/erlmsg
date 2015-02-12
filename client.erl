-module(client).
-export([send/0]).

connect() ->
  receive
    "test" ->
      io:format("this is a test~n"),
      loop();
    _ ->
    io:format({"ok"}),
      loop()
  end.
