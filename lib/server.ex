defmodule Multichat.Server do
  require Logger


  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: true, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = DynamicSupervisor.start_child(Multichat.Server.ConnectionSupervisor, {Multichat.ClientConnection, client})
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end
end
