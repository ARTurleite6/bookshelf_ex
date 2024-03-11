defmodule BookshelfExWeb.ErrorJSONTest do
  use BookshelfExWeb.ConnCase, async: true

  test "renders 404" do
    assert BookshelfExWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert BookshelfExWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
