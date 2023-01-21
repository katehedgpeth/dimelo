defmodule DimeloWeb.SentenceController do
  use DimeloWeb, :controller
  alias Dimelo.{Sentence, Language}

  def index(conn, params) do
    sentences =
      params
      |> get_sentences()
      |> Enum.shuffle()
      |> Enum.take(20)
      |> Sentence.serialize()

    json(conn, sentences)
  end

  defp get_sentences(%{"lang" => code}) do
    Language.sentences(code)
  end

  defp get_sentences(_) do
    Sentence.all()
  end
end
