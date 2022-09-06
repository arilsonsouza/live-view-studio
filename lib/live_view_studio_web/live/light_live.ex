defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  alias Phoenix.LiveView.Socket

  def mount(_params, _session, %Socket{} = socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
      <h1>Front Porch Light</h1>
      <div id="light">
        <div class="meter">
          <span style="width: <%= @brightness %>%">
            <%= @brightness %>%
          </span>
        </div>
      </div>
    """
  end
end
