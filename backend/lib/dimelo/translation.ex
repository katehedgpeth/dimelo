defmodule Dimelo.Translation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dimelo.{Sentence, Repo}

  @type t :: %__MODULE__{
          original_id: Sentence.t(),
          translated_id: Sentence.t()
        }

  @primary_key false
  schema "translations" do
    field :original_id, :id
    field :translated_id, :id

    timestamps()
  end

  @spec new(%{original: Sentence.t(), translated: Sentence.t()}) ::
          {:ok, t()} | {:error, Ecto.Changeset.t()}
  def new(%{original: %Sentence{id: original_id}, translated: %Sentence{id: translated_id}}) do
    %{original_id: original_id, translated_id: translated_id}
    |> changeset()
    |> Repo.insert()
    |> case do
      {:ok, translation} ->
        %{original_id: translated_id, translated_id: original_id}
        |> changeset()
        |> Repo.insert()

        {:ok, translation}

      {:error, error} ->
        {:error, error}
    end
  end

  @spec get_or_create(%{original: Sentence.t(), translated: Sentence.t()}) :: {:ok, t()}
  def get_or_create(
        %{
          original: %Sentence{id: original_id},
          translated: %Sentence{id: translated_id}
        } = data
      ) do
    __MODULE__
    |> Repo.get_by(original_id: original_id, translated_id: translated_id)
    |> case do
      %__MODULE__{} = translation -> {:ok, translation}
      nil -> new(data)
    end
  end

  @doc false
  def changeset(data) do
    %__MODULE__{}
    |> cast(data, [:original_id, :translated_id])
    |> unique_constraint(
      [:original_id, :translated_id],
      name: :translations_original_to_translated_index
    )
    |> unique_constraint(
      [:translated_id, :original_id],
      name: :translations_translated_to_original_index
    )
  end
end
