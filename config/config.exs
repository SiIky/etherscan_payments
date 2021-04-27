# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :etherscan_payments, EtherscanPaymentsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UhSSd9IZP1rNOf116WxKvj6r+n9W9wlNTPcePxPw/sm3QQMpswQZpxMvozSRp8pg",
  render_errors: [view: EtherscanPaymentsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: EtherscanPayments.PubSub,
  live_view: [signing_salt: "Cz+0n4hn"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
