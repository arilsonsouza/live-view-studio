defmodule LiveViewStudio.Incidents.Incident do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :description, :lat, :lng]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "incidents" do
    field :description, :string
    field :lat, :float
    field :lng, :float

    timestamps()
  end

  @doc false
  def changeset(incident, attrs) do
    incident
    |> cast(attrs, [:description, :lat, :lng])
    |> validate_required([:description, :lat, :lng])
  end
end
