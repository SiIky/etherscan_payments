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

  defp timestamp_string_to_integer(timestamp) do
    {timestamp, ""} = Integer.parse(timestamp)
    timestamp
  end

  def transaction_receipt_status(tx_hash) do
    wait_for_rate_limit()
    case Etherscan.get_transaction_receipt_status(tx_hash) do
      # TODO: How to move these out?
      {:ok, "Max rate limit reached"} ->
        transaction_receipt_status(tx_hash)

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
    wait_for_rate_limit()
    case Etherscan.eth_get_transaction_receipt(tx_hash) do
      {:ok, "Max rate limit reached"} ->
        transaction_receipt(tx_hash)

      {:ok, %{blockNumber: _}} = reply ->
        reply

      {:ok, reply} ->
        {:error, {:unexpected_reply, reply}}

      ret -> ret
    end
  end

  def block_and_uncle_rewards(block_no) do
    wait_for_rate_limit()
    case Etherscan.get_block_and_uncle_rewards(block_no) do
      {:ok, "Max rate limit reached"} ->
        block_and_uncle_rewards(block_no)

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
