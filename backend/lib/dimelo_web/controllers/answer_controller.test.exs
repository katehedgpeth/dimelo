defmodule DimeloWeb.AnswerControllerTest do
  use DimeloWeb.ConnCase
  alias DimeloWeb.Router.Helpers, as: Routes
  alias Dimelo.{Repo, Sentence, Seeder}

  setup do
    Seeder.seed_languages()
  end

  describe "POST /api/answers/" do
    test "returns true if answer is correct, regardless of punctuation", %{
      conn: conn,
      english_lang: english
    } do
      MockMe.set_response(:open_ai, :success)

      assert {:ok, %Sentence{id: sentence_id}} =
               Sentence.new(%{text: "Hello, how are you?", language: english})

      path = Routes.answer_path(conn, :post)
      assert path === "/api/answers"

      assert response =
               conn
               |> post(path, %{
                 sentence_id: sentence_id,
                 translation: "Hola, como estas?"
               })
               |> json_response(200)

      assert response === %{"error" => false, "is_a_match" => true}
    end

    test "returns false if answer is not correct", %{
      conn: conn,
      english_lang: english
    } do
      MockMe.set_response(:open_ai, :success)

      assert {:ok, %Sentence{id: sentence_id}} =
               Sentence.new(%{text: "Hello, how are you?", language: english})

      path = Routes.answer_path(conn, :post)
      assert path === "/api/answers"

      assert response =
               conn
               |> post(path, %{
                 sentence_id: sentence_id,
                 translation: "Muy bien, y tu?"
               })
               |> json_response(200)

      assert response === %{"error" => false, "is_a_match" => false}
    end

    @tag validator: {__MODULE__, :success}
    test "returns 404 if sentence doesn't exist", %{conn: conn} do
      assert Repo.get(Sentence, 1) == nil

      assert conn
             |> post(
               Routes.answer_path(conn, :post),
               %{sentence_id: 1, translation: "Hola, como estas"}
             )
             |> json_response(404)
    end

    test "returns 503 for bad gateway", %{conn: conn, english_lang: english} do
      MockMe.set_response(:open_ai, :server_error)

      {:ok, %Sentence{id: id}} =
        Sentence.get_or_create(%{language: english, text: "Hello, how are you?"})

      assert conn
             |> post(
               Routes.answer_path(conn, :post),
               %{sentence_id: id, translation: "Hola como estas?"}
             )
             |> json_response(502)
    end
  end
end
