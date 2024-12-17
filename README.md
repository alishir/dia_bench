# Compile
Run `make` to compile all Erlang modules.

# Server
Start an Erlang shell, `erl` and run the following commands:

```Erlang
diameter:start().
server:start().
server:listen(sctp).
```

# Client
Start an Erlang shell, `erl` and run the following commands:

```Erlang
diameter:start().
client:start().
client:connect(sctp).
```

# Running Benchmark
In the client Erlang shell, run the following command:

``` Erlang
bench:start(5,100).  %% 5 worker each one sends 100 requests
```
