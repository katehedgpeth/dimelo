import React, { FC, useEffect, useContext } from "react";
import { SentenceContext, SetWasCorrect } from "../contexts/SentenceContext";
import { Sentence } from "../services/sentences";
import { SpeechRecognitionResult } from "../services/speech_recognition";

const standardizeText = (text: string): string => (
  text.toLowerCase().replace(/[^\w\s]|_/g, "")
);

const checkAnswer = (
  { transcript }: SpeechRecognitionResult,
  expected: Sentence["translations"],
  setWasCorrect: SetWasCorrect,
): void => {
  const standardizedTranscript = standardizeText(transcript);
  const wasCorrect = expected.some(
    (translation) => (
      standardizedTranscript === standardizeText(translation)
    ),
  );
  setWasCorrect(wasCorrect);
};

const Result: FC<{ result: SpeechRecognitionResult }> = ({
  result: { transcript, confidence },
}) => (
  <>
    <p>{transcript}</p>
    <small><i>{(confidence * 100).toFixed(2)}% Confidence</i></small>
  </>
);

const WasICorrect: FC = () => {
  const { heard, current, setWasCorrect } = useContext(SentenceContext);
  useEffect(() => {
    if (heard === undefined || current === undefined) return;

    const transcripts = Array.from(heard.results);
    if (transcripts.length === 0) throw new Error("nothing was said!");
    if (transcripts.length > 1) throw new Error("got multiple transcripts!");
    checkAnswer(transcripts[0][0], current.translations, setWasCorrect);
  }, [heard]);

  if (heard === undefined || current === undefined) return null;

  const { results: [result] } = heard;
  return (
    <>
      <div>
        <h3>Here is what we just heard:</h3>
        {Array.from(result).map((r) => (
          <Result result={r} key={r.transcript} />
        ))}
      </div>
      <div>
        <h3>We expected to hear one of these:</h3>
        <ul>
          {current.translations.map((t) => <li key={t}>{t}</li>)}
        </ul>
      </div>
    </>
  );
};

export default WasICorrect;
