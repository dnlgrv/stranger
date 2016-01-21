defmodule Stranger.Room do
  use GenServer

  # TODO Prevent duplicate room names

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end


  def all do
    GenServer.call(__MODULE__, :all)
  end

  def by_name(name) do
    Enum.find(all, fn(room) ->
      case room do
        {^name, _, _} -> room
        _ -> nil
      end
    end)
  end

  def by_stranger(id) do
    Enum.find(all, fn(room) ->
      case room do
        {_, ^id, _} -> room
        {_, _, ^id} -> room
        _ -> nil
      end
    end)
  end

  def create(name, id1, id2) do
    GenServer.call(__MODULE__, {:create, {name, id1, id2}})
  end

  def delete(name) do
    GenServer.call(__MODULE__, {:delete, name})
  end

  def delete_by_stranger(id) do
    GenServer.call(__MODULE__, {:delete_by_stranger, id})
  end


  def handle_call(:all, _from, rooms) do
    {:reply, rooms, rooms}
  end

  def handle_call({:create, room}, _from, rooms) do
    {:reply, :ok, [room | rooms]}
  end

  def handle_call({:delete, name}, _from, rooms) do
    rooms = Enum.filter(rooms, fn(room) ->
      case room do
        {^name, _, _} -> false
        _ -> true
      end
    end)

    {:reply, :ok, rooms}
  end

  def handle_call({:delete_by_stranger, id}, _from, rooms) do
    rooms = Enum.filter(rooms, fn(room) ->
      case room do
        {_, ^id, _} -> false
        {_, _, ^id} -> false
        _ -> true
      end
    end)

    {:reply, :ok, rooms}
  end
end
