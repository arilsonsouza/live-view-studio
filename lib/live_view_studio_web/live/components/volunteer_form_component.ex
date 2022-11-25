defmodule LiveViewStudioWeb.VolunteerFormComponent do
  use LiveViewStudioWeb, :live_component

  alias LiveViewStudio.Volunteers
  alias LiveViewStudio.Volunteers.Volunteer

  def mount(socket) do
    {:ok, assign(socket, changeset: Volunteers.change_volunteer(%Volunteer{}))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form let={f} for={@changeset} url="#"
          phx_submit="save",
          phx_change="validate"
          phx_target={@myself}
        >
        <div class="field">
        <%= text_input f, :name, placeholder: "Name", autocomplete: "off", phx_debounce: "2000" %>
        <%= error_tag f, :name %>
        </div>
        <div class="field">
        <%= telephone_input f, :phone, placeholder: "Phone", autocomplete: "off", phx_debounce: "blur" %>
        <%= error_tag f, :phone %>
        </div>

        <%= submit "Check In", phx_disable_with: "Saving..." %>
      </.form>
    </div>
    """
  end

  def handle_event("save", %{"volunteer" => params}, socket) do
    socket =
      case Volunteers.create_volunteer(params) do
        {:ok, _volunteer} ->
          changeset = Volunteers.change_volunteer(%Volunteer{})
          assign(socket, changeset: changeset)

        {:error, %Ecto.Changeset{} = changeset} ->
          assign(socket, changeset: changeset)
      end

    {:noreply, socket}
  end

  def handle_event("validate", %{"volunteer" => params}, socket) do
    changeset =
      %Volunteer{}
      |> Volunteers.change_volunteer(params)
      |> Map.put(:action, :insert)

    socket = assign(socket, changeset: changeset)
    {:noreply, socket}
  end
end
