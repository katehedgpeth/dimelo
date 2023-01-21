defmodule DimeloWeb.SentenceController do
  use DimeloWeb, :controller
  alias Dimelo.{Repo, Sentence}

  def index(conn, _params) do
    sentences =
      Sentence
      |> Repo.all()
      |> Enum.shuffle()
      |> Enum.take(20)
      |> Sentence.serialize()

    json(conn, sentences)
  end
end
