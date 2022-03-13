defmodule Vhs.DelayNotif do
  @moduledoc """
  Genserver background process that will run every second

  This will check for delayed pending transactions
  """

  use GenServer
  require Logger

  alias Vhs.Transactions
  alias Vhs.Clients.Slack

  @delay_notification 120

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Transactions.value
    |> Enum.each(fn(%{delay_flag: delay_flag} = transaction) ->
      if !delay_flag do
        if DateTime.diff(DateTime.utc_now(), transaction.inserted_at) >= @delay_notification do
          Slack.webhook_post(%{
              "hash" => transaction.hash,
              "status" => "Delayed"
            })
          Transactions.update_flag(transaction.hash)
        end
      end 
    end)

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1000)
  end

end
