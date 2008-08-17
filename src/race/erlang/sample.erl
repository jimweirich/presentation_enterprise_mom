-module(sample).

-compile(export_all).

fact(0) ->
    1;
fact(N) ->
    N * fact(N-1).

fact2(N) ->
    fact2(N, 1).

fact2(0, Acc) ->
    Acc;
fact2(N, Acc) ->
    fact2(N-1, N * Acc).
