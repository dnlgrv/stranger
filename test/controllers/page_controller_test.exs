defmodule Stranger.PageControllerTest do
  use Stranger.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello Stranger"
  end

  test "assigns an id" do
    conn = get conn, "/"
    assert conn.assigns.id
  end

  test "GET /agreement", %{conn: conn} do
    conn = get conn, "/agreement"
    assert html_response(conn, 200) =~ "User Agreement"
  end
end
