defmodule Vhs.Clients.Blocknative do
  @moduledoc """
  Interface to communicate with Blocknative's API

  Ideally the client_config will return api keys, network, etc...
  """

  require Logger

  @behaviour Vhs.Behaviors.BlocknativeClient

  @client_config Application.compile_env!(:vhs, :blocknative)

  def watch_tx(%{"tx_id" => tx_id}) when is_list tx_id do
    post_blocknative(tx_id)
  end

  def watch_tx(%{"tx_id" => tx_id}) do
    post_blocknative([tx_id])
  end

  def watch_tx(_body), do: {:error, :error}

  defp post_blocknative([]), do: {:ok}
  defp post_blocknative([tx_id | tails]) do
    request_body = 
      @client_config
      |> Map.drop([:base_url])
      |> Map.put(:hash, tx_id)

    case Vhs.HTTP.post("/transaction", request_body, @client_config) do
      {:ok, response} ->
        {:ok, response}

      {:error, error} ->
        Logger.error(
          "Received error trying to watch #{inspect(tx_id)} with reason #{inspect(error)}"
        )

        {:error, error}
    end

    post_blocknative(tails)
  end

end
