defmodule LiveViewStudioWeb.MapLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Incidents

  def mount(_params, _session, socket) do
    if connected?(socket), do: Incidents.subscribe()

    socket =
      assign(socket,
        incidents: Incidents.list_incidents(),
        selected_incident: nil
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Nearby Incidents</h1>
    <div id="mapping">
      <div class="sidebar">
        <%= for incident <- @incidents do %>
          <div
            class="incident <%= if @selected_incident == incident, do: 'selected' %>"
            phx-click="select-incident"
            phx-value-id="<%= incident.id %>"
            >
            <%= incident.description %>
          </div>
        <% end %>
      </div>
      <div class="main">
        <div id="wrapper" class="w-full" phx-update="ignore">
          <div
            id="map"
            phx-hook="IncidentMap"
            data-incidents="<%= Jason.encode!(@incidents)%>"
            ></div>
        </div>
        <div class="text-center">
          <button phx-click="report-incident">
            Report Incident
          </button>
        </div>
    </div>
    """
  end

  def handle_event("select-incident", %{"id" => id}, socket) do
    incident = find_incident(socket, id)

    socket =
      socket
      |> assign(selected_incident: incident)
      |> push_event("highlight-marker", incident)

    {:noreply, socket}
  end

  def handle_event("report-incident", _params, socket) do
    Incidents.create_random_incident()
    {:noreply, socket}
  end

  def handle_event("marker-clicked", incident_id, socket) do
    incident = find_incident(socket, incident_id)
    {:noreply, assign(socket, selected_incident: incident)}
  end

  def handle_info({:incident_created, incident}, socket) do
    socket =
      socket
      |> update(:incidents, fn incidents -> [incident | incidents] end)
      |> assign(selected_incident: incident)
      |> push_event("add-marker", incident)

    {:noreply, socket}
  end

  defp find_incident(socket, id) do
    Enum.find(socket.assigns.incidents, &(&1.id == id))
  end
end
