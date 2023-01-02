defmodule LiveViewStudioWeb.UnderwaterLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudioWeb.CreaturesComponent

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Earth Is Super Watery</h1>
    <div id="underwater">
      <%= live_patch "🤿 Look Underwater 👀",
         to: Routes.underwater_path(@socket, :show_modal),
         class: "button" %>

      <%= if @live_action == :show_modal do %>
        <%= live_modal @socket,
           CreaturesComponent,
           return_to: Routes.live_path(@socket, __MODULE__),
           title: "Sea Creatures" %>
      <% end %>
    </div>
    """
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
