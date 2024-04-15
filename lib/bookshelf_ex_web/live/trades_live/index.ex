defmodule BookshelfExWeb.TradesLive.Index do
  alias BookshelfEx.Services.AcceptTradeService
  alias BookshelfEx.Accounts
  use BookshelfExWeb, :live_view
  alias BookshelfEx.Trades

  def mount(_params, _session, socket) do
    current_user = Accounts.with_assoc(socket.assigns.current_user, :account)

    trades =
      Trades.user_receiving_trading_requests(current_user.account.id,
        sending_reservation: [:book, user: [:user]]
      )

    socket = stream(socket, :trades, trades)
    {:ok, socket}
  end

  def handle_event("accept", %{"trade_id" => trade_id}, socket) do
    trade = Trades.get_trade!(trade_id)

    case AcceptTradeService.accept_trade(trade) do
      {:ok, {trade, _, _}} ->
        trade = Trades.with_assoc(trade, sending_reservation: [:book, user: [:user]])

        socket =
          socket
          |> put_flash(:info, "Trade accepted successfully")
          |> stream_insert(:trades, trade)

        {:noreply, socket}

      {:error, _} ->
        socket =
          socket
          |> put_flash(:error, "Error accepting the trade")

        {:noreply, socket}
    end
  end
end
