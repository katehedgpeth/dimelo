defmodule Dimelo.Services.ValidationTest do
  use Dimelo.DataCase
  alias Dimelo.{Seeder, Services.Validation, Sentence}

  setup do
    {:ok, [{:english_lang, english}, _]} = Seeder.seed_languages()
    {:ok, sentence} = Sentence.new(%{text: "Hello, how are you?", language: english})
    {:ok, sentence: sentence}
  end

  describe "&validate/2" do
    test "returns true if translation is correct", %{sentence: sentence} do
      MockMe.set_response(:open_ai, :success)
      assert Validation.validate(sentence, "hola como estas") === true
    end

    test "returns false if translation is not correct", %{sentence: sentence} do
      MockMe.set_response(:open_ai, :success)
      assert Validation.validate(sentence, "muy bien, y tu?") === false
    end

    test "returns {:error, error} if bad gateway", %{sentence: sentence} do
      MockMe.set_response(:open_ai, :server_error)

      assert {:error, %HTTPoison.Response{status_code: 500}} =
               Validation.validate(sentence, "hola como estas")
    end
  end
end
