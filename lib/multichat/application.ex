defmodule Multichat.Application do

    use Application


    def start(_type, _args) do
      port = String.to_integer(System.get_env("PORT") || "4001")
      :pg2.create :clients
      
      children = [
        Multichat,
        Multichat.Repo,
        {Task, &Multichat.connect/0},
        {Task.Supervisor, name: Multichat.Server.ConnectionSupervisor},
         Supervisor.child_spec({Task, fn -> Multichat.Server.accept(port) end}, id: :dynamic1)
       ]

      opts = [strategy: :one_for_one, name: Multichat.Supervisor]
      Supervisor.start_link(children, opts)

  end
end
