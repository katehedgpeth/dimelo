defmodule Dimelo.Services.OpenAITest do
  use Dimelo.DataCase
  alias Dimelo.{Sentence, Services.OpenAI, Seeder}

  describe "&fetch_translations/1" do
    setup do
      assert {:ok, [{:english_lang, english}, _]} = Seeder.seed_languages()

      assert {:ok, %Sentence{} = sentence} =
               Sentence.new(%{text: "Hello, how are you?", language: english})

      {:ok, sentence: sentence}
    end

    test "returns a list of strings when response is good", %{sentence: sentence} do
      MockMe.set_response(:open_ai, :success)

      assert OpenAI.fetch_translations(sentence) == [
               "Hola, ¿cómo te encuentras?",
               "¡Hola! ¿Cómo andas?",
               "¡Hola! ¿Cómo te va?",
               "Hola, ¿qué tal?",
               "Hola, ¿cómo estás?"
             ]
    end

    test "returns {:error, %HTTPoison.Response{}} when response is bad", %{sentence: sentence} do
      MockMe.set_response(:open_ai, :server_error)
      assert {:error, %HTTPoison.Response{}} = OpenAI.fetch_translations(sentence)
    end

    @tag timeout: 800
    test "returns {:error, %HTTPoison.Error{}} when request times out", %{
      sentence: sentence,
      timeout: timeout
    } do
      timeout = timeout - 300

      Application.put_env(
        :dimelo,
        OpenAI,
        :dimelo
        |> Application.get_env(OpenAI)
        |> Keyword.put(:timeout, timeout)
      )

      MockMe.set_response(:open_ai, {:timeout, timeout})

      assert {:error, %HTTPoison.Error{reason: :timeout}} = OpenAI.fetch_translations(sentence)
    end
  end

  describe "&parse_translation/2" do
    test "returns accumulator for an empty string" do
      assert OpenAI.parse_translation("", []) == []
      assert OpenAI.parse_translation("?", []) == []
    end

    test "returns sentence without number prefix" do
      text = "Hola, que tal?"
      assert OpenAI.parse_translation("1. " <> text, []) == [text]
    end
  end
end
