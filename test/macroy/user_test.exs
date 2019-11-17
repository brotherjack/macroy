defmodule Macroy.UserTest do
  use Macroy.DataCase
  
  @valid_users_params [
      %{email: "dovakitty@xs4all.nl", password: "FusRoDah=>!"},
      %{email: "wren@nick.com", password: "YouIDIOT!!!"}
  ]

  describe "insert_user/1" do
    test "can insert valid users" do
      with dovakitty <- Enum.at(@valid_users_params, 0),
           wren <- Enum.at(@valid_users_params, 1) do
        assert {:ok, user1} = Macroy.insert_user(dovakitty)
        assert user1.email == dovakitty.email
        assert {:ok, user2} = Macroy.insert_user(wren)
        assert user2.email == wren.email
      end
    end
  end
end
