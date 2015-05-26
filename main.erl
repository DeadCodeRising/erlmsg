#!/usr/bin/env escript

main([]) ->
  S = server:start(),
  C1 = client:connect("Sam",S),
  C1 ! {send, "Hi, anyone here?"},
  C2 = client:connect("Mia",S),
  C3 = client:connect("Luke",S),
  timer:sleep(1000),
  C2 ! {send, "Hello!"},
  timer:sleep(1000),
  C3 ! disconnect,
  timer:sleep(1000).
