defmodule BookshelfExWeb.BookHTML do
  use BookshelfExWeb, :html

  embed_templates "book_html/*"

  def format_genre(genre) do
    genre |> Atom.to_string() |> String.capitalize()
  end

  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  def book_form(assigns)
end
