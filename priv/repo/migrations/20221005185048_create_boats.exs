defmodule LiveViewStudio.Repo.Migrations.CreateBoats do
  use Ecto.Migration

  def change do
    create table(:boats, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :model, :string
      add :type, :string
      add :price, :string
      add :image, :string

      timestamps()
    end
  end
end
