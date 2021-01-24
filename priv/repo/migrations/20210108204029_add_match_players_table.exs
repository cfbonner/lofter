defmodule Lofter.Repo.Migrations.AddMatchPlayersTable do
  use Ecto.Migration

  def change do
    create table(:match_players) do
      add :match_id, references(:matches)
      add :user_id, references(:user)
      add :name, :string
      add :position, :integer
      timestamps()
    end

    alter table(:holes) do
      add :match_player_id, references(:match_players)
    end
  end
end
