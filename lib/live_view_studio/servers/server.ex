defmodule LiveViewStudio.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "servers" do
    field :deploy_count, :integer
    field :framework, :string
    field :git_repo, :string
    field :last_commit_id, :string
    field :last_commit_message, :string
    field :name, :string
    field :size, :float
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:name, :framework, :size, :git_repo, :status])
    |> validate_required([:name, :framework, :size, :git_repo])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:framework, min: 2, max: 50)
    |> validate_length(:git_repo, min: 2, max: 200)
    |> validate_number(:size, greater_than: 0)
    |> validate_inclusion(:status, ["up", "down"])
  end
end
