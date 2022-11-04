defmodule LiveViewStudio.Repo.Migrations.CreatePizzaOrders do
  use Ecto.Migration

  def change do
    create table(:pizza_orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :pizza, :string

      timestamps()
    end
  end
end
