-module(race1).

-compile(export_all).

bump(Account, Pid) ->
    bump(Account, Pid, 100000).
bump(_Account, Pid, 0) ->
    Pid ! ok,
    ok;
bump(Account, Pid, N) ->
    account:credit(Account, 1),
    bump(Account, Pid, N-1).

wait(Account, 0) ->
    io:format("Ending Balance: ~p~n", [account:balance(Account)]),
    io:format("Should Be     : ~p~n", [10 * 100000]),
    ok;
wait(Account, N) ->
    receive
        ok ->
            wait(Account, N-1)
    end.

go() ->
    A = account:start(0),
    go(A).
go(Account) ->
    go(Account, 10),
    wait(Account, 10).
go(_Account, 0) ->
    ok;
go(Account, N) ->
    spawn(race1, bump, [Account, self()]),
    go(Account, N-1).
