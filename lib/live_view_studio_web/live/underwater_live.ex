defmodule LiveViewStudioWeb.UnderwaterLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudioWeb.{ModalComponent, CreaturesComponent}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :show_modal, false)}
  end

  def render(assigns) do
    ~L"""
    <h1>Earth Is Super Watery</h1>
    <div id="underwater">
      <button phx-click="toggle-modal">
        🤿 Look Underwater 👀
      </button>

      <%= if @show_modal do %>
        <%= live_component ModalComponent, component: CreaturesComponent, id: :modal%>
      <% end %>
    </div>
    """
  end

  def handle_event("toggle-modal", _, socket) do
    {:noreply, update(socket, :show_modal, &(!&1))}
  end
end
