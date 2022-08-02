[`:choto`](https://github.com/ruslandoga/choto) + [`:db_connection`](https://github.com/elixir-ecto/db_connection)

```elixir
iex> {:ok, conn} = Choto.Connection.start_link()

iex> DBConnection.prepare_execute(conn, Choto.Connection.Query.new("SELECT 1 + 1"), [])
{:ok, %Choto.Connection.Query{statement: "SELECT 1 + 1", command: :select},
 [data: [[{"plus(1, 1)", :u16}]], data: [[{"plus(1, 1)", :u16}, 2]], data: []]}
```

See also: [`:choto_ecto`](https://github.com/ruslandoga/choto_ecto)
