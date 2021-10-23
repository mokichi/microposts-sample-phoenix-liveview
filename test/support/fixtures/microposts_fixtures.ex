defmodule Sample.MicropostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sample.Microposts` context.
  """

  @doc """
  Generate a micropost.
  """
  def micropost_fixture(attrs \\ %{}) do
    {:ok, micropost} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> Sample.Microposts.create_micropost()

    micropost
  end
end
