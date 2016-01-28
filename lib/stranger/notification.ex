defmodule Stranger.Notification do
  @moduledoc ~S"""
  Broadcasts notifications when anyone connects/disconnects from the
  Notification channel.
  """

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc ~S"""
  Returns the number of strangers in the channel (`pids`).
  """
  def count do
    GenServer.call(__MODULE__, :count)
  end

  @doc ~S"""
  Monitors the `pid` and broadcasts a notification message.
  """
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

  @doc ~S"""
  Called when someone leaves the notification channel. Removes them from the
  list of `pids` and broadcasts a notification message.
  """
  def handle_info({:DOWN, _ref, :process, pid, _reason}, pids) do
    pids = Enum.filter(pids, &(&1 != pid))
    broadcast(Enum.count(pids))
    {:noreply, pids}
  end

  defp broadcast(count) do
    Stranger.Endpoint.broadcast "notification", "stats", %{online: count}
  end
end
