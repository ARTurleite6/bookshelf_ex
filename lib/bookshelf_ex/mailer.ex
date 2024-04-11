defmodule BookshelfEx.Mailer do
  use Swoosh.Mailer, otp_app: :bookshelf_ex

  def default_from do
    {"Deemaze", "bookshelf@deemaze.com"}
  end
end
