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
    |> cast(attrs, [:name, :status, :deploy_count, :size, :framework, :git_repo, :last_commit_id, :last_commit_message])
    |> validate_required([:name, :status, :deploy_count, :size, :framework, :git_repo, :last_commit_id, :last_commit_message])
  end
end
