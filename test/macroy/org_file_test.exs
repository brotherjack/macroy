defmodule Macroy.OrgFileTest do
  use Macroy.DataCase
  alias Macroy.{OrgFile, Todo}

  defp mock_orgfile(filename, host \\ "localhost") do
    %OrgFile{host: host, filename: filename, path: "/"}
  end

  describe "read/1" do
    test "valid orgfile returns valid todos" do
      orgfiles = OrgFile.read(mock_orgfile("usda_prime_org_file.org"))
      with todo_1 <- Enum.at(orgfiles, 0),
           todo_2 <- Enum.at(orgfiles, 1) do
        # Todo 1 and 2 are Todos{} too
        assert %Todo{} = todo_1
        assert %Todo{} = todo_2

        # Todo 1
        assert todo_1.name == "Go over Google Assistant stuff in email"
        assert todo_1.category == "Electronic Organization"
        assert is_nil(todo_1.subcategory)
        assert is_nil(todo_1.closed_on)
        assert is_nil(todo_1.deadline_on)
        assert DateTime.compare(todo_1.scheduled_for, ~U[2019-08-06 04:00:00Z]) == :eq
        refute todo_1.is_done

        # Todo 2
        assert todo_2.name == "Go play in an Elixir stream"
        assert todo_2.category == "Education"
        assert todo_2.subcategory == "Coding"
        assert DateTime.compare(todo_2.closed_on,  ~U[2019-08-18 14:50:00Z]) == :eq
        assert DateTime.compare(todo_2.deadline_on, ~U[2019-08-13 04:00:00Z]) == :eq
        assert DateTime.compare(todo_2.scheduled_for, ~U[2019-08-13 04:00:00Z]) == :eq
        assert todo_2.is_done
      end
    end

    test "todo entries without TODO|DONE will guess based on presence of CLOSED" do
      orgfiles = "entries_missing_todo_n_done.org"
      |> mock_orgfile
      |> OrgFile.read
      with todo_1 <- Enum.at(orgfiles, 0),
           todo_2 <- Enum.at(orgfiles, 1) do
        assert %Todo{} = todo_1
        assert %Todo{} = todo_2

        refute todo_1.is_done
        assert todo_2.is_done
      end
    end
  end
end
