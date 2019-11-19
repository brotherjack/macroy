defmodule Macroy.OrgFileMock do
  @moduledoc false

  def prep_org_file_stream!("/usda_prime_org_file.org") do
    ["* Electronic Organization", "** TODO Go over Google Assistant stuff in email",
 "   SCHEDULED: <2019-08-06 Tue>",
 "* Education", "** Coding", "*** DONE Go play in an Elixir stream",
 "    CLOSED: [2019-08-18 Sun 10:50] DEADLINE: <2019-08-13 Tue> SCHEDULED: <2019-08-13 Tue>"]
  end

  def prep_org_file_stream!("/entries_missing_todo_n_done.org") do
    ["* Electronic Organization", "** Go over Google Assistant stuff in email",
     "   SCHEDULED: <2019-08-06 Tue>",
     "* Education", "** Coding", "*** Go play in an Elixir stream",
     "    CLOSED: [2019-08-18 Sun 10:50] DEADLINE: <2019-08-13 Tue> SCHEDULED: <2019-08-13 Tue>"]
  end
end
