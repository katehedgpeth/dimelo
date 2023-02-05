require Protocol

defmodule DimeloWeb.AnswerController do
  require Protocol
  use DimeloWeb, :controller

  alias Dimelo.{
    Repo,
    Sentence,
    Services.Validation
  }

  Protocol.derive(Jason.Encoder, HTTPoison.Response, only: [:status_code, :body, :headers])

  def post(conn, %{"sentence_id" => sentence_id, "translation" => "" <> translation}) do
    case Repo.get(Sentence, sentence_id) do
      nil ->
        conn
        |> Plug.Conn.put_status(404)
        |> json(%{message: "not_found"})

      sentence ->
        sentence
        |> Validation.validate(translation)
        |> do_post(conn)
    end
  end

  defp do_post(is_a_match?, conn) when is_boolean(is_a_match?) do
    json(conn, %{error: false, is_a_match: is_a_match?})
  end

  defp do_post({:error, error}, conn) do
    conn
    |> put_status(:bad_gateway)
    |> json(%{
      error: true,
      response: encode_error_response(error)
    })
  end

  defp encode_error_response(%HTTPoison.Error{reason: reason}), do: reason

  defp encode_error_response(%HTTPoison.Response{
         status_code: status_code,
         body: body,
         headers: headers
       }) do
    %{status_code: status_code, body: body, headers: Enum.into(headers, %{})}
  end
end
