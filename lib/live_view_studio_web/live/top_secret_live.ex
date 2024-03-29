defmodule LiveViewStudioWeb.TopSecretLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, session, socket) do
    {:ok, assign_current_user(socket, session)}
  end

  def render(assigns) do
    ~L"""
    <h1>Top Secret</h1>
    <div id="top-secret">
      <img src="images/spy.svg"/>
      <div class="mission">
        <h2>Your Mission</h2>
        <h3><%= @current_user.email %></h3>
        <p>
          (should you choose to accept it)
        </p>
        <p>
          is detaild below...
        </p>
      </div>
    </div>
    """
  end
end
