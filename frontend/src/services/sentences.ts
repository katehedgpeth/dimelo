import { useQuery } from "react-query";

export interface Sentence {
  language: "en" | "sp"
  text_punctuated: string;
  translations: string[];
}

const API_URL = "http://localhost:4000/api/sentences/?lang=en";

const fetchSentences = () => fetch(API_URL)
  .then((res) => res.json());

const useSentences = () => useQuery<Sentence[]>(
  "sentences",
  fetchSentences,
);

export default useSentences;
