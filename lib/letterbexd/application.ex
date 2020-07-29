defmodule Letterbexd.Application do
  def start(_type, args) do
    children =
      case args do
        [env: :prod] ->
          []

        [env: :test] ->
          [{Plug.Cowboy, scheme: :http, plug: Letterbexd.MockServer, options: [port: 8081]}]

        [env: :dev] ->
          []

        [_] ->
          []
      end

    opts = [strategy: :one_for_one, name: Letterbexd.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
