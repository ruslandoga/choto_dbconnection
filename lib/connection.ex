defmodule Choto.Connection do
  @moduledoc """
  This module imlements connection details as defined in DBConnection.
  """

  # NOTE: txs are not implemeted yet: https://github.com/ClickHouse/ClickHouse/issues/22086

  use DBConnection

  defmodule Error do
    defexception [:message]
  end

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :show_sensitive_data_on_connection_error, true)
    DBConnection.start_link(__MODULE__, opts)
  end

  def child_spec(opts) do
    DBConnection.child_spec(__MODULE__, opts)
  end

  @impl true
  def connect(opts) do
    host = Keyword.get(opts, :host) || {127, 0, 0, 1}
    port = Keyword.get(opts, :port) || 9000
    Choto.connect(host, port, opts)
  end

  @impl true
  def disconnect(_err, conn) do
    :ok = Choto.close(conn)
  end

  @impl true
  def checkout(conn) do
    # TODO can be idle/busy? if checking out busy, should disconnect and return exception
    {:ok, conn}
  end

  @impl true
  def handle_status(_, conn) do
    {:idle, conn}
  end

  @impl true
  def ping(conn) do
    :ok = Choto.ping(conn)
    # TODO await one packet
    {:ok, conn}
  end

  @impl true
  def handle_prepare(query, _opts, conn) do
    {:ok, query, conn}
  end

  @impl true
  def handle_close(_query, _opts, conn) do
    {:ok, :ok, conn}
  end

  @impl true
  def handle_execute(query, params, _opts, conn) do
    :ok = Choto.query(conn, query)

    if params do
      :ok = Choto.send_data(conn, params)
    end

    {:ok, packets, conn} = Choto.await(conn)
    # TODO telemetry for profile_events and others
    response = Enum.filter(packets, fn packet -> match?({:data, _data}, packet) end)
    {:ok, response, conn}
  end

  @impl true
  def handle_declare(_query, _params, _opts, conn) do
    {:error, Error.exception("cursors not supported"), conn}
  end

  @impl true
  def handle_deallocate(_query, _cursor, _opts, conn) do
    {:error, Error.exception("cursors not supported"), conn}
  end

  @impl true
  def handle_fetch(_query, _cursor, _opts, conn) do
    {:error, Error.exception("cursors not supported"), conn}
  end

  @impl true
  def handle_begin(_opts, conn) do
    {:ok, :ok, conn}
  end

  @impl true
  def handle_commit(_opts, conn) do
    {:ok, :ok, conn}
  end

  @impl true
  def handle_rollback(_opts, conn) do
    {:ok, :ok, conn}
  end
end
