defmodule LiveViewStudioWeb.CreaturesComponent do
  use LiveViewStudioWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <div class="creatures">
        🐙 🐳 🦑 🐡 🐚 🐋 🐟 🦈 🐠 🦀 🐬
      </div>

      <button phx-click="toggle-modal">
        I'm outta air!
      </button>
    </div>
    """
  end
end
