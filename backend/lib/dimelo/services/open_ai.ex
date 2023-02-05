defmodule Dimelo.Services.OpenAI do
  alias Dimelo.Sentence
  @max_results 5

  @spec fetch_translations(Sentence.t()) ::
          List.t(String.t()) | {:error, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def fetch_translations(%Sentence{} = prompt) do
    body =
      Jason.encode!(
        %{
          prompt:
            "Translate this into Spanish up to #{@max_results} different ways:" <>
              prompt.text_punctuated,
          model: "text-davinci-003",
          temperature: 0.3,
          frequency_penalty: 0,
          presence_penalty: 0,
          max_tokens: 300
        },
        escape: :json
      )

    headers = [{:Authorization, "Bearer " <> token()}, {"Content-type", "application/json"}]
    timeout = config() |> Keyword.get(:timeout, 30_000)

    url()
    |> HTTPoison.post(body, headers, recv_timeout: timeout)
    |> parse_response()
  end

  @spec parse_response({:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}) ::
          List.t(String.t()) | {:error, HTTPoison.Error.t()}
  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    %{"choices" => [%{"text" => text}]} = Jason.decode!(body)

    text
    |> String.split("\n")
    |> Enum.reduce([], &parse_translation/2)
  end

  defp parse_response({:ok, %HTTPoison.Response{} = response}) do
    {:error, response}
  end

  defp parse_response(error), do: error

  def parse_translation("", acc), do: acc
  def parse_translation("?", acc), do: acc

  for int <- Range.new(1, @max_results) |> Enum.map(&Integer.to_string/1) do
    def parse_translation("#{unquote(int)}. " <> <<ai::binary>>, acc) do
      [ai | acc]
    end
  end

  def token do
    token = config() |> Keyword.fetch!(:token)
    if token === nil, do: raise("missing env var: OPEN_AI_TOKEN")
    token
  end

  defp url do
    config()
    |> Keyword.fetch!(:url)

    # |> Path.join("/v1/completions")
  end

  def config do
    Application.get_env(:dimelo, __MODULE__)
  end
end
