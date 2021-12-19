defmodule Lofter.Repo.Migrations.CreateFriendships do
  use Ecto.Migration

  def change do
    create table(:friendships) do
      add :user_id, references(:user)
      add :friend_id, references(:user)
      add :last_actioned_by, :integer
      add :status, :string

      timestamps()
    end

    create index(:friendships, [:user_id])
    create index(:friendships, [:friend_id])

    create unique_index(
             :friendships,
             [:user_id, :friend_id],
             name: :friendships_user_id_friend_id_index
           )

    create unique_index(
             :friendships,
             [:friend_id, :user_id],
             name: :friendships_friend_id_user_id_index
           )
  end
end
