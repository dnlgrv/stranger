defmodule Stranger.Lobby do
  @moduledoc ~S"""
  Holds the IDs and Channel PIDs of all strangers in the lobby channel.

  Monitors the Channel PID so that if the stranger leaves the channel
  they're removed here.
  """

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, {%{}, %{}}, name: __MODULE__)
  end

  @doc ~S"""
  Find a Channel PID of a stranger with the `id`.
  """
  def find(id) do
    GenServer.call(__MODULE__, {:find, id})
  end

  @doc ~S"""
  Adds a stranger with the `id` and `pid`.
  """
  def join(id, pid) do
    GenServer.call(__MODULE__, {:join, id, pid})
  end

  @doc ~S"""
  Removes a stranger with the `id`.
  """
  def leave(id) do
    GenServer.call(__MODULE__, {:leave, id})
  end

  @doc ~S"""
  Retrieve the `id` of all connected strangers.
  """
  def strangers do
    GenServer.call(__MODULE__, :strangers)
  end


  @doc false
  def handle_call(:strangers, _from, {refs, _pids} = strangers) do
    ids = Enum.map(refs, fn({k, _v}) -> k end)
    {:reply, ids, strangers}
  end

  @doc false
  def handle_call({:find, id}, _from, {refs, _pids} = strangers) do
    {:reply, Map.get(refs, id), strangers}
  end

  @doc ~S"""
  State contains a key for both the `id` and `pid`, so we can look up the
  stranger by both references. Monitors the `pid` process for `:DOWN`.
  """
  def handle_call({:join, id, pid}, _from, {refs, pids}) do
    Process.monitor(pid)

    refs = Map.put(refs, id, pid)
    pids = Map.put(pids, pid, id)

    {:reply, :ok, {refs, pids}}
  end

  @doc ~S"""
  Removes both `id` and `pid` references from state.
  """
  def handle_call({:leave, id}, _from, {refs, pids}) do
    pid = Map.get(refs, id)
    refs = Map.delete(refs, id)
    pids = Map.delete(pids, pid)

    {:reply, :ok, {refs, pids}}
  end

  @doc ~S"""
  Removes both `id` and `pid` references from state if the linked process
  goes down.
  """
  def handle_info({:DOWN, _ref, :process, pid, _reason}, {refs, pids}) do
    id = Map.get(pids, pid)
    refs = Map.delete(refs, id)
    pids = Map.delete(pids, pid)

    {:noreply, {refs, pids}}
  end
end
