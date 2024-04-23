defmodule BookshelfExWeb.TradesLive.Index do
  alias BookshelfEx.Services.AcceptTradeService
  alias BookshelfEx.Accounts
  use BookshelfExWeb, :live_view
  alias BookshelfEx.Trades

  def mount(_params, _session, socket) do
    current_user = Accounts.with_assoc(socket.assigns.current_user, :account)

    trades =
      current_user.account.id
      |> Trades.user_involved_trades()
      |> Trades.preload_reservations()

    socket = socket |> stream(:trades, trades) |> assign(current_user: current_user)
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

  def handle_event("deny", %{"trade_id" => trade_id}, socket) do
    trade = Trades.get_trade!(trade_id) |> Trades.preload_reservations()

    case Trades.update_trade_availability(trade, %{status: :rejected}) do
      {:ok, trade} ->
        socket = socket |> put_flash(:info, "Trade Denied") |> stream_insert(:trades, trade)
        {:noreply, socket}

      {:error, _} ->
        socket =
          put_flash(socket, :error, "Couldn't deny the trade")

        {:noreply, socket}
    end
  end
end
