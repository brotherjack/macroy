defmodule Macroy.UserTest do
  use Macroy.DataCase

  @dovakitty %{email: "dovakitty@xs4all.nl", password: "FusRoDah=>!"}
  @wren %{email: "wren@nick.com", password: "YouIDIOT!!!"}
  

  describe "insert_user/1" do
    test "can insert valid users" do
      assert {:ok, user1} = Macroy.insert_user(@dovakitty)
      assert user1.email == @dovakitty.email
      assert {:ok, user2} = Macroy.insert_user(@wren)
      assert user2.email == @wren.email
    end

    test "rejects user changesets without valid fields" do
      assert {:error, _} = Macroy.insert_user(Map.take(@dovakitty, [:email]))
      assert {:error, _} = Macroy.insert_user(Map.take(@wren, [:email]))
    end

    test "rejects user changesets with invalid emails" do
      user_w_invalid_email = Map.put(@dovakitty, :email, "derp S**t @ n")
      assert {:error, _} = Macroy.insert_user(user_w_invalid_email)
    end
  end
end
