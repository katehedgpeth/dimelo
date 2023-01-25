import React, {
  FC,
  Dispatch,
  useContext,
  FormEvent,
  SetStateAction,
} from "react";
import { Sentence } from "../services/sentences";
import { SentenceContext, State } from "../contexts/SentenceContext";
import ListenButton from "./ListenButton";
import SubmitButton from "./SubmitButton";
import TextBox from "./TextBox";

const standardizeText = (text: string): string => (
  text.toLowerCase().replace(/[^\w\s]|_/g, "")
);

const checkAnswer = (
  transcript: string,
  expected: Sentence["translations"],
  setState: Dispatch<SetStateAction<State>>,
): void => {
  const standardizedTranscript = standardizeText(transcript);
  const wasCorrect = expected.some(
    (translation) => (
      standardizedTranscript === standardizeText(translation)
    ),
  );
  setState((oldState) => ({
    ...oldState,
    wasCorrect,
  }));
};

type NamedFormEvent = FormEvent<HTMLFormElement> & {
  target: { userInput: HTMLTextAreaElement }
}

const InputForm: FC = () => {
  const {
    handlers: { setState },
    state: { sentences: { current } },
  } = useContext(SentenceContext);

  if (!current) return null;

  const onSubmit = (input: string) => (
    checkAnswer(input, current.translations, setState)
  );

  return (
    <form onSubmit={(e: NamedFormEvent) => {
      e.preventDefault();
      onSubmit(e.target.userInput.value);
    }}
    >
      <TextBox onSubmit={onSubmit} />
      <div>
        <ListenButton />
        <SubmitButton />
      </div>
    </form>
  );
};

export default InputForm;
