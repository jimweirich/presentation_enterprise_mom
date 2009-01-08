-module(race4).

-compile(export_all).

transfer(From, To, Pid) ->
    case account:debit(From, 1) of
        ok ->
            account:credit(To, 1),
            transfer(From, To, Pid);
        error ->
            Pid ! ok,
            ok
    end.

wait(From, To, 0) ->
    io:format("From Balance: ~p~n", [account:balance(From)]),
    io:format("To   Balance: ~p~n", [account:balance(To)]),
    ok;
wait(From, To, N) ->
    receive
        ok ->
            wait(From, To, N-1)
    end.

go() ->
    A = account:start(100000),
    B = account:start(0),
    go(A,B).
go(From, To) ->
    go(From, To, 10),
    wait(From, To, 10).
go(_From, _To, 0) ->
    ok;
go(From, To, N) ->
    spawn(race4, transfer, [From, To, self()]),
    go(From, To, N-1).
