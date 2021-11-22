defmodule CleanArchitecture.MixProject do
  use Mix.Project
  @test_envs [:test, :integration]

  def project do
    [
      app: :clean_architecture,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: test_paths(Mix.env()),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CleanArchitecture, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:argon2_elixir, "~> 2.0"},
      {:httpoison, "~> 1.7", only: @test_envs},
      {:credo, "~> 1.5", only: [:dev] ++ @test_envs, runtime: false}
    ]
  end

  defp elixirc_paths(env) when env in @test_envs, do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support/stringify_map_keys", "test/support/factory.ex"]
  defp elixirc_paths(_), do: ["lib"]

  defp test_paths(:integration), do: ["test/integration"]
  defp test_paths(_), do: ["test/unit"]

  defp aliases do
    [
      "test.unit": &unit_test/1,
      "test.integration": &integration_test/1
    ]
  end

  defp unit_test(args) do
    Mix.Task.run("compile")
    Mix.Task.run("test", ["--exclude", "integration" | args])
  end

  defp integration_test(args) do
    Mix.Task.run("ecto.drop", ["--quiet"])
    Mix.Task.run("ecto.create", ["--quiet"])
    Mix.Task.run("ecto.migrate", ["--quiet"])
    args = if IO.ANSI.enabled?(), do: ["--color" | args], else: ["--no-color" | args]

    {_, res} =
      System.cmd(
        "mix",
        ["do", "compile", ",", "test", "--only", "integration" | args],
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", "integration"}]
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end
end
