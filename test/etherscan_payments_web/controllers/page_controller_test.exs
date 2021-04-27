defmodule EtherscanPaymentsWeb.PageControllerTest do
  use EtherscanPaymentsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Transaction Hash:"
  end

  test "POST /?tx_hash=0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0", %{conn: conn} do
    conn = post(conn, "/", [tx_hash: "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"])
    result = html_response(conn, 200)
    assert result =~ "Transaction Hash: 0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"
    assert result =~ "Block Number: 4954885"
    assert result =~ "Timestamp: 2018-01-22 23:19:34Z"
    assert result =~ "Successfully processed transaction: true"
  end

  test "POST /?tx_hash=0x40eb908387324f2b575b4879cd9d7188f69c8fc9d87c901b9e2daaea4b442170", %{conn: conn} do
    conn = post(conn, "/", [tx_hash: "0x40eb908387324f2b575b4879cd9d7188f69c8fc9d87c901b9e2daaea4b442170"])
    result = html_response(conn, 200)
    assert result =~ "Transaction Hash: 0x40eb908387324f2b575b4879cd9d7188f69c8fc9d87c901b9e2daaea4b442170"
    assert result =~ "Block Number: 1743059"
    assert result =~ "Timestamp: 2016-06-21 06:11:38Z"
    assert result =~ "Successfully processed transaction: false"
  end
end
