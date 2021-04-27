defmodule EtherscanPaymentsWeb.PageController do
  use EtherscanPaymentsWeb, :controller
  alias EtherscanPayments.EtherscanAPI

  def get(conn, _params) do
    render(conn, "get.html")
  end

  def post(conn, %{"tx_hash" => tx_hash}) do
    # TODO: Where/How do we get the number of block confirmations from the API?
    # NOTE: Ignoring all errors here for simplicity.
    {:ok, status} = EtherscanAPI.transaction_receipt_status(tx_hash)
    {:ok, %{blockNumber: block_no}} = EtherscanAPI.transaction_receipt(tx_hash)
    {:ok, %{timeStamp: timestamp}} = EtherscanAPI.block_and_uncle_rewards(block_no)
    render(conn, "post.html",
      tx_hash: tx_hash,
      block_no: block_no,
      timestamp: DateTime.from_unix!(timestamp),
      status: status)
  end
end
