defmodule EtherscanPayments.EtherscanAPI do
  @name __MODULE__
  @time_window 1_000
  @calls_per_window 5

  # NOTE: This alone is not flawless
  defp wait_for_rate_limit() do
    case ExRated.inspect_bucket(@name, @time_window, @calls_per_window) do
      {_, 0, ms_to_next_bucket, _, _} -> Process.sleep(ms_to_next_bucket)
      _ -> :ok
    end
  end

  defp wait_for_rate_limit(call) do
    wait_for_rate_limit()
    case call.() do
      {:ok, "Max rate limit reached"} -> wait_for_rate_limit(call)
      ret -> ret
    end
  end

  defp timestamp_string_to_integer(timestamp) do
    {timestamp, ""} = Integer.parse(timestamp)
    timestamp
  end

  def transaction_receipt_status(tx_hash) do
    call = fn () -> Etherscan.get_transaction_receipt_status(tx_hash) end
    case wait_for_rate_limit(call) do
      {:ok, %{"status" => "1"}} ->
        {:ok, true}

      {:ok, %{"status" => _}} ->
        {:ok, false}

      {:ok, reply} ->
        {:error, {:unexpected_reply, reply}}

      ret -> ret
    end
  end

  def transaction_receipt(tx_hash) do
    call = fn () -> Etherscan.eth_get_transaction_receipt(tx_hash) end
    case wait_for_rate_limit(call) do
      {:ok, %{blockNumber: _}} = reply ->
        reply

      {:ok, reply} ->
        {:error, {:unexpected_reply, reply}}

      ret -> ret
    end
  end

  def block_and_uncle_rewards(block_no) do
    call = fn () -> Etherscan.get_block_and_uncle_rewards(block_no) end
    case wait_for_rate_limit(call) do
      {:ok, %{
        blockNumber: _,
        timeStamp: timestamp,
      }=reply} ->
        {:ok, %{reply | timeStamp: timestamp_string_to_integer(timestamp)}}

      {:ok, reply} ->
        {:error, {:unexpected_reply, reply}}

      ret -> ret
    end
  end
end
