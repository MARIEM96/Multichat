defmodule Multichat.ClientConnection do
  use GenServer

  def start_link(socket), do: GenServer.start_link(__MODULE__, socket)
  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_call({:send, message}, _from, socket) do
    :gen_tcp.send(socket, message)
    {:reply, :ok, socket}
  end

  def handle_info({:tcp, _socket, message}, socket) do
    for {_, pid, _, _} <- DynamicSupervisor.which_children(Multichat.Server.ConnectionSupervisor) do
      if pid != self() do
        GenServer.call(pid, {:send, message})
      end
    end

    {:noreply, socket}
  end
end
