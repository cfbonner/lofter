defmodule Lofter.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table "matches" do
      add :course, :string
      add :length, :integer
      timestamps()
    end

    create table "holes" do
      add :par,      :integer
      add :strokes,  :integer
      add :position, :integer
      add :match_id, references(:matches)
      timestamps()
    end
  end
end
