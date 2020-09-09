import Config

config :multichat, Multichat.Repo,
  database: "multichat_repo",
  username: "postgres",
  password: "nadhir",
  hostname: "localhost"
config :multichat, ecto_repos: [Multichat.Repo]
