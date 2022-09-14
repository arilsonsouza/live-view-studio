defmodule LiveViewStudioWeb.AutocompleteLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.{Stores, Cities}

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        zip: "",
        city: "",
        matches: [],
        stores: [],
        loading: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <h1>Findo a Store</h1>
      <div id="search">

        <form phx-submit="zip-search">
          <input
            type="text"
            name="zip"
            value="<%= @zip %>"
            placeholder="Zip Code"
            autofocus
            autocomplete="off"
            <%= if @loading, do: "readonly" %>
          />
          <button type="submit">
            <img src="images/search.svg"/>
          </button>
        </form>

        <form phx-submit="city-search" phx-change="suggest-city">
          <input
            type="text"
            name="city"
            value="<%= @city %>"
            placeholder="City"
            autocomplete="off"
            list="matches"
            phx-debounce="1000"
            <%= if @loading, do: "readonly" %>
          />
          <button type="submit">
            <img src="images/search.svg"/>
          </button>
        </form>

        <datalist id="matches">
          <%= for match <- @matches do %>
            <option value="<%= match %>"><%= match %></option>
          <% end %>
        </datalist>

        <%= if @loading do %>
          <div class="loader">
            Loading...
          </div>
        <% end %>

        <div class="stores">
          <ul>
            <%= for store <- @stores do %>
              <li>
                <div class="first-line">
                  <div class="name">
                    <%= store.name %>
                  </div>
                  <div class="status">
                      <%= if store.open do %>
                        <span class="open">Open</span>
                      <% else %>
                        <span class="closed">Closed</span>
                      <% end %>
                  </div>
                </div>
                <div class="second-line">
                  <div class="street">
                    <img src="images/location.svg"/>
                    <%= store.street %>
                  </div>
                  <div class="phone_number">
                    <img src="images/phone.svg"/>
                    <%= store.phone_number %>
                  </div>
                </div>
              </li>
            <% end %>
          </ul>
        </div>
      </div>
    """
  end

  def handle_event("zip-search", %{"zip" => zip}, socket) do
    send(self(), {:run_zip_search, zip})

    socket =
      assign(socket,
        zip: zip,
        stores: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_event("city-search", %{"city" => city}, socket) do
    send(self(), {:run_city_search, city})

    socket =
      assign(socket,
        city: city,
        stores: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_event("suggest-city", %{"city" => prefix}, socket) do
    socket = assign(socket, matches: Cities.suggest(prefix))
    {:noreply, socket}
  end

  def handle_info({:run_zip_search, zip}, socket),
    do: seach_by(&Stores.search_by_zip/1, zip, socket)

  def handle_info({:run_city_search, city}, socket),
    do: seach_by(&Stores.search_by_city/1, city, socket)

  defp seach_by(serach_func, arg, socket) do
    case serach_func.(arg) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "Not store matching \"#{arg}\"")
          |> assign(stores: [], loading: false)

        {:noreply, socket}

      stores ->
        socket = assign(socket, stores: stores, loading: false)
        {:noreply, socket}
    end
  end
end
