# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :sport_api, SportApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2APNF0s6TTC86wauMTGVLsp0Yrg1CjWHlwJc2SeU22WCK+09ijxvxyfxAmNzzrTs",
  render_errors: [view: SportApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SportApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
