defmodule MacroyWeb.Helpers do
  @moduledoc false

  def flash_message_contains(conn, key, text) do
    conn_flash = Phoenix.Controller.get_flash(conn)
    String.contains?(Map.get(conn_flash, key), text) 
  end
end
