defmodule Dimelo.Language do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Dimelo.{ Repo, Sentence }

  @type t :: %__MODULE__{
    code: String.t(),
    name_eng: String.t(),
    name_sp: String.t()
  }

  @primary_key {:id, :id, autogenerate: true}
  schema "languages" do
    field :code, :string
    field :name_eng, :string
    field :name_sp, :string
    has_many :sentences, Sentence

    timestamps()
  end

  @spec new(%{
          :code => binary,
          :name_eng => binary,
          :name_sp => binary,
        }) :: any
  def new(%{code: "" <> _, name_eng: "" <> _, name_sp: "" <> _} = data) do
    data
    |> changeset()
    |> Repo.insert()
  end

  @doc false
  defp changeset(language \\ %__MODULE__{}, attrs) do
    language
    |> cast(attrs, [:name_eng, :name_sp, :code])
    |> validate_required([:name_eng, :name_sp, :code])
    |> unique_constraint(:code)
    |> unique_constraint(:name_sp)
    |> unique_constraint(:name_eng)
  end

  @spec get_by_code(binary) :: {:error, :not_found} | {:ok, t()}
  def get_by_code(code) do
    l in __MODULE__
    |> from(where: [code: ^code])
    |> Repo.all()
    |> case do
      [%__MODULE__{} = lang] -> {:ok, lang}
      [] -> {:error, :not_found}
    end
  end

  @spec sentences(binary) :: [Sentence.t()]
  def sentences(code) do
    {:ok, lang} = get_by_code(code)
    lang
    |> Repo.preload(:sentences)
    |> Map.get(:sentences)
  end
end
