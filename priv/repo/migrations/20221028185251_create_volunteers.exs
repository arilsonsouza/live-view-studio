defmodule LiveViewStudio.Repo.Migrations.CreateVolunteers do
  use Ecto.Migration

  def change do
    create table(:volunteers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :phone, :string
      add :checked_out, :boolean, default: false, null: false

      timestamps()
    end
  end
end
