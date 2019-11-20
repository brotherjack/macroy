defmodule  MacroyWeb.OrgFileControllerTest do
  use MacroyWeb.ConnCase
  alias Macroy.{OrgFile, Repo}

  @blorp_org %OrgFile{
    host: "localhost",
    path: "/home/blorp",
    filename: "crime.org"
  }

  @css_org %OrgFile{
    host: "localhost",
    path: "/home/css",
    filename: "communism.org"
  }

  setup do
    Macroy.insert_org_file(@blorp_org)
    Macroy.insert_org_file(@css_org)
  end

  describe "index/2" do
    test "all files load" do
      conn = get(conn, "/orgfiles")

      # Page doesn't explode in flames
      resp = html_response(conn, 200)
     
      # Assert that each orgfile shows up 
      assert resp =~ @blorp.path
      assert resp =~ @ccs_org.path
    end
  end
end
