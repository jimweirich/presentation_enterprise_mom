-module(account).

-compile(export_all).

start(StartingBalance) ->
    spawn(account, account_server, [StartingBalance]).

stop(AccountPid) ->
    AccountPid ! shutdown.

get_response() ->
    receive
        ok ->
            ok;
        error ->
            error
    end.

debit(AccountPid, Amount) ->
    AccountPid ! {debit, self(), Amount},
    get_response().

credit(AccountPid, Amount) ->
    AccountPid ! {credit, self(), Amount},
    get_response().

balance(AccountPid) ->
    AccountPid ! {balance, self()},
    receive
        {balance, Balance} ->
            Balance
    end.

account_server(Balance) ->
    receive
        shutdown ->
            io:format("Shutting down~n");
        {debit, Pid, Amount} when (Balance - Amount) >= 0 ->
            Pid ! ok,
            account_server(Balance - Amount);
        {debit, Pid, _Amount} ->
            Pid ! error,
            account_server(Balance);
        {credit, Pid, Amount} ->
            Pid ! ok,
            account_server(Balance + Amount);
        {balance, Pid} ->
            Pid ! {balance, Balance},
            account_server(Balance)
    end.
