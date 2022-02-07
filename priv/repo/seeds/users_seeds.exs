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

defmodule Lofter.UsersSeeds do
  @moduledoc """
  This module defines seed helpers for creating entities 
  """

  @user_names ~w(
    Mila Nova Kai Aaliyah Braxton Zion Maeve Mia Ivy Luca Urban Aria Aurora Kayden Eliana Hunter Amelia Amara
    Lyla Quinn Atlas Elliot Lucas Alice Parker Avery River Noelle Skylar Hayden Alaina Zoey Millie Liam
    Remi Logan Shia Molly Riley Ezra Reese Asher Jude Isla Olivia Ava Malia Jalen Luna Isabella
    Asa Rowan Mya Evan Arlo Zane Arabella Grayson Savannah Thea Leilani Milo Jasmine Harper Sloan Oliver
    Rhea Hudson Arden Axel Evie Maverick Kian Leo Charlotte Alyssa Louise Mateo Amaya Landon Zayne Sahil
    Alani Noah Ariella Xavier Willow Gigi Alina Finn Miles Levi Nora Lennox Dior Remington Zara Maya
    Josie Adeline Delilah Chloe Ximena Owen Ethan Bailey Aliyah Rohan Adonis Hadley Elias Emma Wyatt Tiana
    Austin Caleb Sydney Sophia Ace Addison Adriel Everett Elijah Madison Penelope Wren Zia Kailani Xyla Nia
    Rhys Brielle Elaine Naomi August Stella Jayden Theodore Genevieve Hannah Octavia Atticus Layla Rory Valerie Willa
    Adira Juliana Penny Alexander Jade Margot Ira Grace Sage Abigail Ashton Maira Jocelyn Cairo Eleanor Jasper
    Ari Audrey Ella Myra Alex Huxley Nancy Henry Everly Eloise Nevaeh Benjamin Mabel Leia Javier Bella
    Jolene Rai Azariah Rylee Josiah Veda Keilani Leah Lily Scarlett Zuri Gianna Adalyn Aurelia Aaron Ada
    Roman Mina Nyla Colin Pat Katie Jane Brian Cynthia
  ) 

  @password "P4$$word!"
  
  def unique_user_email(name \\ System.unique_integer()), do: "#{name}@user.com"

  def register_user(name) do
    Lofter.Accounts.register_user(
      %{ email: unique_user_email(name), password: @password }
    )
  end

  def seed_users() do
    Enum.map(@user_names, &register_user/1)
  end
end

Lofter.UsersSeeds.seed_users
