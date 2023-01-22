# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dimelo.Repo.insert!(%Dimelo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Dimelo.{Language, Sentence, Repo, Seeder}

Seeder.seed_languages()
[english_lang, spanish_lang] = Repo.all(Language)

"DATA_FOLDER"
|> System.get_env()
|> Path.join("*.json")
|> Path.absname()
|> Path.wildcard()
|> Enum.each(fn path ->
  {:ok, str} = File.read(path)
  {:ok, sentences} = Jason.decode(str)

  Enum.each(sentences, fn %{"english" => [english], "spanish" => [spanish]} ->
    Seeder.seed_sentence(%{english: english, spanish: spanish},
      english_lang: english_lang,
      spanish_lang: spanish_lang
    )
  end)
end)

Sentence
|> Repo.all()
|> length()
|> IO.inspect(label: "TOTAL SENTENCE COUNT")
