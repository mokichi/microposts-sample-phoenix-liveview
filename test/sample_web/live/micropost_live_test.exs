defmodule SampleWeb.MicropostLiveTest do
  use SampleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sample.MicropostsFixtures

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  defp create_micropost(_) do
    micropost = micropost_fixture()
    %{micropost: micropost}
  end

  describe "Index" do
    setup [:create_micropost]

    test "lists all microposts", %{conn: conn, micropost: micropost} do
      {:ok, _index_live, html} = live(conn, Routes.micropost_index_path(conn, :index))

      assert html =~ "Listing Microposts"
      assert html =~ micropost.content
    end

    test "saves new micropost", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.micropost_index_path(conn, :index))

      assert index_live |> element("a", "New Micropost") |> render_click() =~
               "New Micropost"

      assert_patch(index_live, Routes.micropost_index_path(conn, :new))

      assert index_live
             |> form("#micropost-form", micropost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#micropost-form", micropost: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.micropost_index_path(conn, :index))

      assert html =~ "Micropost created successfully"
      assert html =~ "some content"
    end

    test "updates micropost in listing", %{conn: conn, micropost: micropost} do
      {:ok, index_live, _html} = live(conn, Routes.micropost_index_path(conn, :index))

      assert index_live |> element("#micropost-#{micropost.id} a", "Edit") |> render_click() =~
               "Edit Micropost"

      assert_patch(index_live, Routes.micropost_index_path(conn, :edit, micropost))

      assert index_live
             |> form("#micropost-form", micropost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#micropost-form", micropost: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.micropost_index_path(conn, :index))

      assert html =~ "Micropost updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes micropost in listing", %{conn: conn, micropost: micropost} do
      {:ok, index_live, _html} = live(conn, Routes.micropost_index_path(conn, :index))

      assert index_live |> element("#micropost-#{micropost.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#micropost-#{micropost.id}")
    end
  end

  describe "Show" do
    setup [:create_micropost]

    test "displays micropost", %{conn: conn, micropost: micropost} do
      {:ok, _show_live, html} = live(conn, Routes.micropost_show_path(conn, :show, micropost))

      assert html =~ "Show Micropost"
      assert html =~ micropost.content
    end

    test "updates micropost within modal", %{conn: conn, micropost: micropost} do
      {:ok, show_live, _html} = live(conn, Routes.micropost_show_path(conn, :show, micropost))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Micropost"

      assert_patch(show_live, Routes.micropost_show_path(conn, :edit, micropost))

      assert show_live
             |> form("#micropost-form", micropost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#micropost-form", micropost: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.micropost_show_path(conn, :show, micropost))

      assert html =~ "Micropost updated successfully"
      assert html =~ "some updated content"
    end
  end
end
