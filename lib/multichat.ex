defmodule Multichat do
  import Chat.Nodes
  use GenServer

  def start_link(args) do
    name = {:global, :"#{node()}-chat"} |> IO.inspect(label: "Name")
    GenServer.start_link(__MODULE__, args, name: name)
  end

  def  insert_into_database() do
    list = get_nodes()
    unless Enum.member?(list, node()) do
      user= %Chat.Nodes{name: node()}
      Multichat.Repo.insert(user)
    end
  end

  def connect() do
    insert_into_database()
    for noeud <- get_nodes() do
      unless node() == noeud do
      Node.connect(noeud)
      end
    end
  end

  def disconnect() do
    name = node()
    delete_user(name)
    for noeud <- get_nodes() do
    Node.disconnect(noeud)
    end
  end

  def get_nodes() do
   for i <- get_users() do
     y = Enum.reduce( Tuple.to_list(i), fn(x,acc)-> x <> acc end)
    IO.inspect(y)
   end
  end
  def init(_) do
    :net_kernel.monitor_nodes(true)
    {:ok, []}
  end


  def send_message(message) do
    for noeud <- Node.list()|> IO.inspect(label: "Destinataire") do
      GenServer.cast({:global, :"#{noeud}-chat"}, {:receive, message})
    end
  end

  def handle_cast({:receive, message}, state) do
    IO.puts(message)
    {:noreply, state}
  end

  def handle_info(params, state) do
    params |> IO.inspect(label: "Params")
    {:noreply, state}
  end


  def close() do
    disconnect()
    Node.stop
  end
end
