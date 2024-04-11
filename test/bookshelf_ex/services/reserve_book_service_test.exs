defmodule BookshelfEx.Services.ReserveBookServiceTest do
  use BookshelfEx.DataCase
  import BookshelfEx.Factory
  import Swoosh.TestAssertions

  describe "reserve_book/2" do
    test "it creates the reservation" do
      book = insert(:book)
      user = insert(:account)
      assert {:ok, _} = BookshelfEx.Services.ReserveBookService.reserve_book(book, user)
    end
  end
end
