defmodule Stranger.Lobby do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add(id) do
    GenServer.call(__MODULE__, {:add, id})
  end

  def remove(id) do
    GenServer.call(__MODULE__, {:remove, id})
  end

  def all do
    GenServer.call(__MODULE__, :all)
  end


  def handle_call(:all, _from, ids) do
    {:reply, ids, ids}
  end

  def handle_call({:add, id}, _from, ids) do
    {:reply, :ok, [id | ids]}
  end

  def handle_call({:remove, id}, _from, ids) do
    {:reply, :ok, Enum.filter(ids, &(&1 != id))}
  end
end
