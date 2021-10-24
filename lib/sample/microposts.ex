defmodule Sample.Microposts do
  @moduledoc """
  The Microposts context.
  """

  import Ecto.Query, warn: false
  alias Sample.Repo

  alias Sample.Microposts.Micropost

  @doc """
  Returns the list of microposts.

  ## Examples

      iex> list_microposts()
      [%Micropost{}, ...]

  """
  def list_microposts do
    Repo.all(from m in Micropost, order_by: [desc: m.id])
  end

  @doc """
  Gets a single micropost.

  Raises `Ecto.NoResultsError` if the Micropost does not exist.

  ## Examples

      iex> get_micropost!(123)
      %Micropost{}

      iex> get_micropost!(456)
      ** (Ecto.NoResultsError)

  """
  def get_micropost!(id), do: Repo.get!(Micropost, id)

  @doc """
  Creates a micropost.

  ## Examples

      iex> create_micropost(%{field: value})
      {:ok, %Micropost{}}

      iex> create_micropost(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_micropost(attrs \\ %{}) do
    %Micropost{}
    |> Micropost.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:micropost_created)
  end

  @doc """
  Updates a micropost.

  ## Examples

      iex> update_micropost(micropost, %{field: new_value})
      {:ok, %Micropost{}}

      iex> update_micropost(micropost, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_micropost(%Micropost{} = micropost, attrs) do
    micropost
    |> Micropost.changeset(attrs)
    |> Repo.update()
    |> broadcast(:micropost_updated)
  end

  @doc """
  Deletes a micropost.

  ## Examples

      iex> delete_micropost(micropost)
      {:ok, %Micropost{}}

      iex> delete_micropost(micropost)
      {:error, %Ecto.Changeset{}}

  """
  def delete_micropost(%Micropost{} = micropost) do
    micropost
    |> Repo.delete()
    |> broadcast(:micropost_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking micropost changes.

  ## Examples

      iex> change_micropost(micropost)
      %Ecto.Changeset{data: %Micropost{}}

  """
  def change_micropost(%Micropost{} = micropost, attrs \\ %{}) do
    Micropost.changeset(micropost, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Sample.PubSub, "microposts")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(Sample.PubSub, "microposts", {event, post})
    {:ok, post}
  end
end
