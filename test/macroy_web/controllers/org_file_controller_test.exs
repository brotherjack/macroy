defmodule  MacroyWeb.OrgFileControllerTest do
  use MacroyWeb.ConnCase
  alias Macroy.{OrgFile, Repo}

  @blorp_org %{
    host: "localhost",
    path: "/home/blorp",
    filename: "crime.org"
  }

  @css_org %{
    host: "localhost",
    path: "/home/css",
    filename: "communism.org"
  }

  setup do
    Repo.insert(OrgFile.changeset(%OrgFile{}, @blorp_org))
    Repo.insert(OrgFile.changeset(%OrgFile{}, @css_org))
  end

  describe "index/2" do
    test "all files load", %{conn: conn} do
      # Page doesn't explode in flames
      resp = conn
      |> get("/orgfiles")
      |> html_response(200)
     
      # Assert that each orgfile shows up 
      assert resp =~ @blorp_org.path
      assert resp =~ @css_org.path
    end
  end
end
