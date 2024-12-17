-module(bench).
-export([
    start/0,
    start/2,
    worker/2
]).

start() ->
    start(100, 10000).

start(WorkerCount, RequestPerWorker) ->
    Seq = lists:seq(1, WorkerCount),
    Pids = lists:map(fun(_) -> spawn(?MODULE, worker, [RequestPerWorker, wait]) end, Seq),
    lists:map(fun(Pid) -> Pid ! start end, Pids).

worker(N, wait) ->
    io:format("ready to start ...~n"),
    receive
        start ->
            io:format("started.~n"),
            worker(N)
    end.

worker(0) ->
    io:format("finished.~n"),
    [];
worker(N) ->
    client:call(),
    worker(N - 1).
