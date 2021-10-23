defmodule SampleWeb.MicropostLive.FormComponent do
  use SampleWeb, :live_component

  alias Sample.Microposts

  @impl true
  def update(%{micropost: micropost} = assigns, socket) do
    changeset = Microposts.change_micropost(micropost)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"micropost" => micropost_params}, socket) do
    changeset =
      socket.assigns.micropost
      |> Microposts.change_micropost(micropost_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"micropost" => micropost_params}, socket) do
    save_micropost(socket, socket.assigns.action, micropost_params)
  end

  defp save_micropost(socket, :edit, micropost_params) do
    case Microposts.update_micropost(socket.assigns.micropost, micropost_params) do
      {:ok, _micropost} ->
        {:noreply,
         socket
         |> put_flash(:info, "Micropost updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_micropost(socket, :new, micropost_params) do
    case Microposts.create_micropost(micropost_params) do
      {:ok, _micropost} ->
        {:noreply,
         socket
         |> put_flash(:info, "Micropost created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
