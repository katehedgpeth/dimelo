import React, {
  createContext,
  Dispatch,
  FC,
  PropsWithChildren,
  SetStateAction,
  useEffect,
  useMemo,
  useState,
} from "react";
import useSentences, { Sentence } from "../services/sentences";
import { SpeechRecognitionEvent } from "../services/speech_recognition";

interface Sentences {
  current?: Sentence,
  next: Sentence[],
  previous: Sentence[]
}

export type SetCurrent = Dispatch<SetStateAction<Sentences>>;
export type SetHeard = Dispatch<
  SetStateAction<SpeechRecognitionEvent | undefined>
>;
export type SetWasCorrect = Dispatch<SetStateAction<boolean | undefined>>;
export type SetIsSpeaking = Dispatch<SetStateAction<boolean>>;

interface Context {
  current?: Sentence;
  heard?: SpeechRecognitionEvent;
  isLoading: boolean;
  isSpeaking: boolean;
  error?: unknown;
  wasCorrect?: boolean;
  setCurrent: SetCurrent
  setHeard: SetHeard;
  setIsSpeaking: SetIsSpeaking;
  setWasCorrect: SetWasCorrect;
}

export const SentenceContext = createContext<Context>({
  isLoading: true,
  isSpeaking: false,
  setCurrent: () => undefined,
  setHeard: () => undefined,
  setIsSpeaking: () => false,
  setWasCorrect: () => undefined,
});

const SentenceContextProvider: FC<PropsWithChildren> = ({ children }) => {
  const [wasCorrect, setWasCorrect] = useState<boolean>();
  const [{ current }, setCurrent] = useState<Sentences>({
    next: [],
    previous: [],
  });
  const [heard, setHeard] = useState<SpeechRecognitionEvent>();
  const [isSpeaking, setIsSpeaking] = useState<boolean>(false);

  const { isLoading, data, error } = useSentences();

  useEffect(() => {
    if (isLoading) return;
    if (data && !current) {
      const [first, ...rest] = data;
      setCurrent((state) => ({ ...state, current: first, next: rest }));
    }
  }, [isLoading, data]);

  const context = useMemo<Context>(() => ({
    current,
    error,
    heard,
    isLoading,
    isSpeaking,
    setCurrent,
    setHeard,
    setIsSpeaking,
    setWasCorrect,
    wasCorrect,
  }), [
    current,
    error,
    heard,
    isLoading,
    isSpeaking,
    wasCorrect,
  ]);

  return (
    <SentenceContext.Provider
      value={context}
    >
      {children}
    </SentenceContext.Provider>
  );
};

export default SentenceContextProvider;
