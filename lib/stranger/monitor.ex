defmodule Stranger.Monitor do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def count do
    GenServer.call(__MODULE__, :count)
  end

  def monitor(pid) do
    GenServer.cast(__MODULE__, {:monitor, pid})
  end


  def handle_call(:count, _from, pids) do
    {:reply, Enum.count(pids), pids}
  end

  def handle_cast({:monitor, pid},  pids) do
    Process.monitor(pid)
    pids = [pid | pids]
    broadcast(Enum.count(pids))
    {:noreply, pids}
  end

  def handle_info({:DOWN, _ref, :process, pid, _reason}, pids) do
    pids = Enum.filter(pids, &(&1 != pid))
    broadcast(Enum.count(pids))
    {:noreply, pids}
  end

  defp broadcast(count) do
    Stranger.Endpoint.broadcast "notification", "stats", %{online: count}
  end
end
