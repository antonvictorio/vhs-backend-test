defmodule Vhs.Transactions do

  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def increment(hash) do
    Agent.update(__MODULE__, fn list -> 
      list ++ [hash]
    end)
  end

  def update(%{"status" => "pending"} = chain_response) do
    increment(%{
      hash: chain_response["hash"],
      inserted_at: DateTime.utc_now(),
      delay_flag: false
    })
  end

  def update(%{"status" => "confirmed"} = chain_response) do
    Agent.update(__MODULE__, fn list -> 
      Enum.reject(list, &(&1.hash == chain_response["hash"]))
    end)
  end

  def update(_), do: nil

  def update_flag(hash) do
    Agent.update(__MODULE__, fn list -> 
      list
      |> Enum.map(fn(transaction) -> 
        if transaction.hash == hash do
          Map.put(transaction, :delay_flag, true)
        else
          transaction
        end        
      end)
    end)
  end

end
