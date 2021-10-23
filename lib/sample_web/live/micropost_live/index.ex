defmodule SampleWeb.MicropostLive.Index do
  use SampleWeb, :live_view

  alias Sample.Microposts
  alias Sample.Microposts.Micropost

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :microposts, list_microposts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Micropost")
    |> assign(:micropost, Microposts.get_micropost!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Micropost")
    |> assign(:micropost, %Micropost{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Microposts")
    |> assign(:micropost, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    micropost = Microposts.get_micropost!(id)
    {:ok, _} = Microposts.delete_micropost(micropost)

    {:noreply, assign(socket, :microposts, list_microposts())}
  end

  defp list_microposts do
    Microposts.list_microposts()
  end
end
