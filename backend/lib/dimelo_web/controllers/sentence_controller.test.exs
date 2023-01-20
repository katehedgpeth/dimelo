defmodule DimeloWeb.QuestionControllerTest do
  use DimeloWeb.ConnCase

  test "GET /api/sentence", %{conn: conn} do
    conn = get(conn, "/api/sentence")
    assert json_response(conn, 200) == %{}
  end
end
