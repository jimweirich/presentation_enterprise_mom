-module(race7).

-compile(export_all).

pause() ->
    receive
        never_sent ->
            error
    after 1000 ->
            ok
    end.

accounts(0) ->
    [];
accounts(N) ->
    [ account:start(1000) | accounts(N-1) ].

transfer(From, To, Pid) ->
    pause(),
    case account:debit(From, 1) of
        ok ->
            pause(),
            account:credit(To, 1);
        error ->
            ok
    end,
    Pid ! ok,
    ok.

start_all() ->
    Accounts = accounts(5),
    [A, B, C, D, E] = Accounts,
    spawn(race7, transfer, [A, B, self()]),
    spawn(race7, transfer, [B, C, self()]),
    spawn(race7, transfer, [C, D, self()]),
    spawn(race7, transfer, [D, E, self()]),
    spawn(race7, transfer, [E, A, self()]),
    Accounts.

wait([], 0) ->
    ok;
wait([H | T], 0) ->
    io:format("Balance: ~p~n", [account:balance(H)]),
    wait(T, 0);
wait(Accounts, N) ->
    receive
        ok ->
            wait(Accounts, N-1)
    end.
    
go() ->
    wait(start_all(), 5).
