defmodule LiveViewStudio.IncidentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewStudio.Incidents` context.
  """

  @doc """
  Generate a incident.
  """
  def incident_fixture(attrs \\ %{}) do
    {:ok, incident} =
      attrs
      |> Enum.into(%{
        description: "some description",
        lat: 120.5,
        lng: 120.5
      })
      |> LiveViewStudio.Incidents.create_incident()

    incident
  end
end
