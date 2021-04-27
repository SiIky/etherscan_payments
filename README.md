# EtherscanPayments

The Etherscan API key has to be set in the `config/etherscan_key.exs` file for
the project to work.

## Problem Statement

> Please write a new Elixir Phoenix application capable of performing the
> following flow of tasks:
>
> 1. Have a web page that allows a user to enter an ETH transaction hash
>    (tx_hash). This will simulate a payment throughout the challenge.
> 2. Receive the tx_hash and treat that as a sign that payment was received.
> 3. Perform confirmation of the payment. This can be done in a number of ways,
>    but integrating with the Etherscan API or scrapping the specific tx_hash
>    page are good starting points.
> 4. Once there are at least two block confirmations of the transaction, mark
>    the payment as complete.
>
> Other relevant points:
>
> * There should be at least a test that exercises the submission of payment,
>   feel free to add more.
> * If you want to use a frontend framework for the web portion of the
>   challenge, please use React. Using or not a frontend framework is
>   completely up to you.
> * Any styling should not use any frameworks such as Bootstrap or Foundation

## Project Overview

Most of the files automatically created by Phoenix are "stock", not changed at
all. The only routes are `GET /` and `POST /`:

```
page_path	GET /	EtherscanPaymentsWeb.PageController	:get
page_path	POST /	EtherscanPaymentsWeb.PageController	:post
```

The `GET /` endpoint just shows a form where a user may input a transation
hash, with a submit action that `POST`s said hash. The `POST /` endpoint
simulates the transaction hash being received and handled (even though right
now no action "requires" a POST).

Both routes are handled by the (default) page `Page`:

 * `lib/etherscan_payments_web/controllers/page_controller.ex`
 * `lib/etherscan_payments_web/views/page_view.ex`
 * `lib/etherscan_payments_web/templates/page/get.html.eex` (corresponding to
   the `GET` endpoint)
 * `lib/etherscan_payments_web/templates/page/post.html.eex` (corresponding to
   the `POST` endpoint)

The heart of the project is in the `PageController`, where the Etherscan API is
called to get info for the received transaction hash. The Etherscan API
documentation is very incomplete, and it took me several tries to learn of the
relevant endpoints -- and even then, I haven't found where or how to obtain the
number of block confirmations from the API. Another pain point was that the
wanted info was spread across 3 different endpoints. With a rate limit of 5 API
calls per second on Etherscan's end, one easily gets back "Max rate limit
reached" replies. To fight this, I wrapped the required calls with a rate
limiting library (can be found in the `lib/etherscan_payments/EtherscanAPI.ex`
file). There's much to improve in this wrapper, but it serves its simple
purpose as an MVP.

Errors were largely ignored for simplicity's sake. And so was CSRF protection.
