defmodule LiveViewStudio.Desks.Desk do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "desks" do
    field :name, :string
    field :photo_urls, {:array, :string}, default: []

    timestamps()
  end

  @doc false
  def changeset(desk, attrs) do
    desk
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
