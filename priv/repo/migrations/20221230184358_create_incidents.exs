defmodule LiveViewStudio.Repo.Migrations.CreateIncidents do
  use Ecto.Migration

  def change do
    create table(:incidents, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :lat, :float
      add :lng, :float

      timestamps()
    end
  end
end
