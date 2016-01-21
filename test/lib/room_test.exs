defmodule Stranger.RoomTest do
  use ExUnit.Case, async: true

  alias Stranger.Room

  setup do
    on_exit fn ->
      room_names =
        Room.all()
        |> Enum.map(fn(room) ->
          room |> Tuple.to_list() |> List.first()
        end)

      Enum.each(room_names, &Room.delete/1)
    end
  end

  test "creating and deleting a room" do
    Room.create("random_name", "stranger1", "stranger2")
    assert Room.all() == [
      {"random_name", "stranger1", "stranger2"}
    ]

    Room.delete("random_name")
    assert Room.all() == []
  end

  test "finding a room by name" do
    Room.create("random_name", "stranger1", "stranger2")
    assert Room.by_name("random_name") == {"random_name", "stranger1", "stranger2"}

    refute Room.by_name("wrong")
  end

  test "deleting a room by stranger" do
    Room.create("random_name", "stranger1", "stranger2")
    Room.delete_by_stranger("stranger1")

    assert Room.all() == []

    Room.create("random_name", "stranger1", "stranger2")
    Room.delete_by_stranger("stranger2")

    assert Room.all() == []
  end

  test "finding by stranger" do
    Room.create("random_name", "stranger1", "stranger2")

    assert {"random_name", _, _} = Room.by_stranger("stranger1")
    assert {"random_name", _, _} = Room.by_stranger("stranger2")
  end
end
