import Config

# Set the `:username` config value here with your Name or Github handler.
config :vhs,
  username: "antonvictorio",
  blocknative: %{
    apiKey: "a8726be1-9514-4a6d-9ca6-4dba395751ca",
    blockchain: "ethereum",
    network: "kovan",
    base_url: "https://api.blocknative.com"
  },
  slack: %{
    base_url: "https://hooks.slack.com/services",
    webhook_key: "https://hooks.slack.com/services/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"
  }
