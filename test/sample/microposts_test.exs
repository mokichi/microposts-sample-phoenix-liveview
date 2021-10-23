defmodule Sample.MicropostsTest do
  use Sample.DataCase

  alias Sample.Microposts

  describe "microposts" do
    alias Sample.Microposts.Micropost

    import Sample.MicropostsFixtures

    @invalid_attrs %{content: nil}

    test "list_microposts/0 returns all microposts" do
      micropost = micropost_fixture()
      assert Microposts.list_microposts() == [micropost]
    end

    test "get_micropost!/1 returns the micropost with given id" do
      micropost = micropost_fixture()
      assert Microposts.get_micropost!(micropost.id) == micropost
    end

    test "create_micropost/1 with valid data creates a micropost" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Micropost{} = micropost} = Microposts.create_micropost(valid_attrs)
      assert micropost.content == "some content"
    end

    test "create_micropost/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Microposts.create_micropost(@invalid_attrs)
    end

    test "update_micropost/2 with valid data updates the micropost" do
      micropost = micropost_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Micropost{} = micropost} = Microposts.update_micropost(micropost, update_attrs)
      assert micropost.content == "some updated content"
    end

    test "update_micropost/2 with invalid data returns error changeset" do
      micropost = micropost_fixture()
      assert {:error, %Ecto.Changeset{}} = Microposts.update_micropost(micropost, @invalid_attrs)
      assert micropost == Microposts.get_micropost!(micropost.id)
    end

    test "delete_micropost/1 deletes the micropost" do
      micropost = micropost_fixture()
      assert {:ok, %Micropost{}} = Microposts.delete_micropost(micropost)
      assert_raise Ecto.NoResultsError, fn -> Microposts.get_micropost!(micropost.id) end
    end

    test "change_micropost/1 returns a micropost changeset" do
      micropost = micropost_fixture()
      assert %Ecto.Changeset{} = Microposts.change_micropost(micropost)
    end
  end
end
