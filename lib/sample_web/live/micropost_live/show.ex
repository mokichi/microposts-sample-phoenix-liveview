defmodule SampleWeb.MicropostLive.Show do
  use SampleWeb, :live_view

  alias Sample.Microposts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:micropost, Microposts.get_micropost!(id))}
  end

  defp page_title(:show), do: "Show Micropost"
  defp page_title(:edit), do: "Edit Micropost"
end
