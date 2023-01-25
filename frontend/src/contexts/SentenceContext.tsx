import React, {
  createContext,
  Dispatch,
  FC,
  PropsWithChildren,
  SetStateAction,
  useCallback,
  useEffect,
  useMemo,
  useState,
} from "react";
import { UseQueryResult } from "react-query";
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
export type SetSubmitted = Dispatch<SetStateAction<string | undefined>>

export interface State {
  sentences: Sentences;
  error?: unknown;
  heard?: SpeechRecognitionEvent;
  isLoading: boolean;
  isSpeaking: boolean;
  submitted?: string;
  wasCorrect?: boolean;
}

interface Handlers {
  onClickNext: () => void;
  setState: Dispatch<SetStateAction<State>>
}

interface Context {
  state: State,
  handlers: Handlers
}

const defaultState: State = {
  isLoading: true,
  isSpeaking: false,
  sentences: {
    next: [],
    previous: [],
  },
};

const defaultHandlers: Handlers = {
  onClickNext: () => undefined,
  setState: () => undefined,
};

export const SentenceContext = createContext<Context>({
  handlers: defaultHandlers,
  state: defaultState,
});

const moveToNextQuestion = (
  refetchSentences: UseQueryResult["refetch"],
): SetStateAction<State> => (
  (state) => {
    const { sentences: { current, next, previous } } = state;
    if (!current) return state;
    if (next.length === 0) {
      refetchSentences();
      return state;
    }
    const [newCurrent, ...newNext] = next;
    return {
      ...state,
      heard: undefined,
      sentences: {
        current: newCurrent,
        next: newNext,
        previous: [current, ...previous],
      },
      submitted: undefined,
      wasCorrect: undefined,
    };
  }
);

const SentenceContextProvider: FC<PropsWithChildren> = ({ children }) => {
  const {
    isLoading, data, error, refetch: refetchSentences,
  } = useSentences();
  const [state, setState] = useState<State>({
    ...defaultState,
    error,
    isLoading,
  });

  useEffect(() => {
    setState((oldState) => {
      const sentences: Sentences = data
        ? { ...oldState.sentences, current: data[0], next: data.slice(1) }
        : oldState.sentences;

      return {
        ...oldState,
        error,
        isLoading,
        sentences,
      };
    });
  }, [isLoading, data, error]);

  const onClickNext = useCallback(() => {
    setState(moveToNextQuestion(refetchSentences));
  }, []);

  useEffect(() => {
    setState({
      ...state,
      wasCorrect: undefined,
    });
  }, [state.submitted]);

  const context = useMemo<Context>(() => ({
    handlers: { onClickNext, setState },
    state,
  }), [state]);

  return (
    <SentenceContext.Provider
      value={context}
    >
      {children}
    </SentenceContext.Provider>
  );
};

export default SentenceContextProvider;
