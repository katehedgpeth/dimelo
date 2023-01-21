defmodule DimeloWeb.QuestionControllerTest do
  use DimeloWeb.ConnCase

  setup do
    Dimelo.Seeder.seed()
  end

  test "GET /api/sentences", %{conn: conn} do
    conn = get(conn, "/api/sentences")
    assert response = json_response(conn, 200)
    assert length(response) == 6

    Enum.each(response, fn sentence ->
      assert %{
               "id" => id,
               "text" => "" <> _,
               "language" => lang,
               "translations" => translations
             } = sentence

      assert is_integer(id)
      assert lang in ["en", "sp"]
      assert is_list(translations)
      assert length(translations) > 0

      assert Enum.all?(translations, &is_binary/1)
    end)
  end
end
