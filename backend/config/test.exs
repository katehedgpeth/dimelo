import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dimelo, Dimelo.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "dimelo_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dimelo, DimeloWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "0WtdSk8s+c7ek17J8wbEIjoG3v4ZwwQv8WfpwLGP2XhuQo2EZ/UePSnjWbKT6YmY",
  server: false

# In test we don't send emails.
config :dimelo, Dimelo.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :mock_me, port: 9081
