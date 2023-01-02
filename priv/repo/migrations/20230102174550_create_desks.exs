defmodule LiveViewStudio.Repo.Migrations.CreateDesks do
  use Ecto.Migration

  def change do
    create table(:desks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :photo_urls, {:array, :string}, null: false, default: []

      timestamps()
    end
  end
end
