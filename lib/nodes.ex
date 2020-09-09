defmodule Chat.Nodes do
  use Ecto.Schema



  import Ecto.Query
  alias Chat.Nodes
  alias Multichat.Repo


  schema "nodes" do
    field :name, AtomType
  end



  def delete_user(nom) do
    query = from u in Nodes,
          where: u.name == ^nom

    Repo.delete_all(query)
  end

   def get_users() do
    query = from n in Nodes,
      select: {n.name}
    query
    |> Repo.all
  end



end
