# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Lofter.Repo.insert!(%Lofter.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Lofter.SeedUtils do
  @moduledoc """
  This module defines seed helpers for creating entities 
  """

  @default_names ["colin", "pat", "katie", "jane", "brain", "cynthia"]
  @password "passwordpassword"
  
  def unique_user_email(name \\ System.unique_integer()), do: "#{name}@user.com"

  def register_user(name) do
    Lofter.Accounts.register_user(
      %{ email: unique_user_email(name), password: @password }
    )
  end

  def seed_users(usernames \\ @default_names) do
    Enum.map(usernames, fn name -> register_user(name) end)
  end
end

# Lofter.SeedUtils.seed_users(["velma", "keith", "june", "kevin"])
Lofter.SeedUtils.seed_users()
