ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Stranger.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Stranger.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Stranger.Repo)

