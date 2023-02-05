ExUnit.start()
MockMe.start()
Ecto.Adapters.SQL.Sandbox.mode(Dimelo.Repo, :manual)

Application.put_env(
  :dimelo,
  Dimelo.Services.OpenAI,
  Dimelo.Services.OpenAI.config()
  |> Keyword.put(:url, "http://localhost:#{Application.get_env(:mock_me, :port)}")
)

Application.ensure_all_started(:hackney)

mock_routes = [
  %MockMe.Route{
    name: :open_ai,
    path: "/",
    method: :post,
    responses: [
      %MockMe.Response{
        flag: :server_error,
        body: "",
        status_code: 500
      },
      %MockMe.Response{
        flag: :success,
        body:
          Jason.encode!(%{
            "choices" => [
              %{
                "finish_reason" => "stop",
                "index" => 0,
                "logprobs" => nil,
                "text" =>
                  Enum.join(
                    [
                      "?",
                      "",
                      "",
                      "1. Hola, ¿cómo estás?",
                      "2. Hola, ¿qué tal?",
                      "3. ¡Hola! ¿Cómo te va?",
                      "4. ¡Hola! ¿Cómo andas?",
                      "5. Hola, ¿cómo te encuentras?"
                    ],
                    "\n"
                  )
              }
            ],
            "created" => 1_674_757_119,
            "id" => "cmpl-6d17XY59lPBNsvi2DIjYvIRyvjqpv",
            "model" => "text-davinci-003",
            "object" => "text_completion",
            "usage" => %{
              "completion_tokens" => 76,
              "prompt_tokens" => 17,
              "total_tokens" => 93
            }
          })
      }
    ]
  }
]

MockMe.add_routes(mock_routes)
MockMe.start_server()
