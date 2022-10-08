defmodule LiveViewStudio.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :item, :string
      add :emoji, :string
      add :quantity, :integer
      add :days_until_expires, :integer

      timestamps()
    end
  end
end
