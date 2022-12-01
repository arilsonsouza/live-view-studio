defmodule LiveViewStudioWeb.LicenseLive do
  use LiveViewStudioWeb, :live_view

  import Number.Currency

  alias Phoenix.LiveView.Socket
  alias LiveViewStudio.Licenses

  def mount(_params, _session, %Socket{} = socket) do
    socket = assign(socket, seats: 2, amount: Licenses.calculate(2))
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <h1>Team License</h1>
      <div id="license">
        <div class="card">
          <div class="content">
            <div id="seats" class="seats">
              <img src="images/license.svg"/>
              <span>
                Your license is currently for
                <strong><%= @seats %></strong> seats.
              </span>
            </div>

            <form id="update-seats" phx-change="update">
              <input
                type="range"
                min="1"
                max="10"
                name="seats"
                value="<%= @seats %>"
              />
            </form>

            <div id="amount" class="amount">
              <%= number_to_currency(@amount) %>
            </div>
          </div>
        </div>
      </div>
    """
  end

  def handle_event("update", %{"seats" => seats}, socket) do
    seats = String.to_integer(seats)
    socket = assign(socket, seats: seats, amount: Licenses.calculate(seats))
    {:noreply, socket}
  end
end
