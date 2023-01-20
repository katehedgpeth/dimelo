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

all_sentences = Dimelo.Sentence |> Dimelo.Repo.all()

"../../dimelo_recorder/data/*.json"
|> Path.absname()
|> Path.wildcard()
|> Enum.each(fn path ->
  {:ok, str} = File.read(path)
  {:ok, sentences} = Jason.decode(str)
  Enum.each(sentences, fn %{"english" => [english], "spanish" => [spanish]} ->
    unless Enum.any?(all_sentences, & &1.english === english) do
      %Dimelo.Sentence{english: english, spanish: spanish}
      |> IO.inspect()
      |> Dimelo.Repo.insert!()
    end
  end)
end)

Dimelo.Sentence
|> Dimelo.Repo.all()
|> length()
|> IO.inspect(label: "TOTAL SENTENCE COUNT")
