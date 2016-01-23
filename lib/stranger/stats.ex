defmodule Stranger.Stats do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def all do
    GenServer.call(__MODULE__, :all)
  end

  def decrement(key) do
    GenServer.cast(__MODULE__, {:adjust, key, -1})
  end

  def increment(key) do
    GenServer.cast(__MODULE__, {:adjust, key, 1})
  end

  def reset do
    GenServer.call(__MODULE__, :reset)
  end


  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:reset, _from, _state) do
    {:reply, %{}, %{}}
  end

  def handle_cast({:adjust, key, amount}, state) do
    value = Map.get(state, key, 0)
    state = Map.put(state, key, value + amount)
    {:noreply, state}
  end
end
