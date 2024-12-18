-module(bench).
-export([
    start/0,
    start/2,
    worker/3
]).

start() ->
    start(100, 10000).

start(WorkerCount, RequestPerWorker) ->
    diameter:start(),
    Seq = lists:seq(1, WorkerCount),
    Pids = lists:map(fun(Id) -> spawn(?MODULE, worker, [Id, RequestPerWorker, wait]) end, Seq),
    timer:sleep(10000),
    lists:map(fun(Pid) -> Pid ! start end, Pids),
    ok.

worker(Id0, N, wait) ->
    Id1 = string:concat("client_", integer_to_list(Id0)),
    Id = list_to_atom(Id1),
    ok = client:start(Id, []),
    {ok, _TRef} = client:connect(Id, sctp),
    receive
        start ->
            io:format("started ~p.~n", [Id]),
            worker(Id, N)
    end.

worker(Id, 0) ->
    io:format("finished ~p.~n", [Id]),
    [];
worker(Id, N) ->
    ok = client:call(Id, #{}),
    worker(Id, N - 1).
