defmodule Sample.Repo.Migrations.CreateMicroposts do
  use Ecto.Migration

  def change do
    create table(:microposts) do
      add :content, :string

      timestamps()
    end
  end
end
