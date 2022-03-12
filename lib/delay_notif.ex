defmodule Vhs.DelayNotif do

  use GenServer
  require Logger

  alias Vhs.Transactions
  alias Vhs.Clients.Slack

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Enum.map(Transactions.value, fn(%{delay_flag: delay_flag} = transaction) ->
      case delay_flag do
         false ->
          if DateTime.diff(DateTime.utc_now(), transaction.inserted_at) >= 10 do
            Slack.webhook_post(%{
                "hash" => transaction.hash,
                "status" => "Delayed"
              })
            Transactions.update_flag(transaction.hash)
          end
         _ ->
          nil  
      end 
    end)

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1000) # Every second
  end

end
