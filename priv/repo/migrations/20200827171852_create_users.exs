defmodule Multichat.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:nodes, primary_key: true) do
      add(:name, :atom)
    end

  end
end
