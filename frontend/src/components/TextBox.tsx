import React, {
  ChangeEvent, FC, KeyboardEvent, useCallback, useContext,
} from "react";
import { SentenceContext } from "../contexts/SentenceContext";

interface Props {
  onSubmit(input: string): void
}
type OnChangeCB = (e: ChangeEvent<HTMLTextAreaElement>) => void

const TextBox: FC<Props> = ({ onSubmit }) => {
  const {
    handlers: { setState },
  } = useContext(SentenceContext);

  const onChange = useCallback<OnChangeCB>((e) => {
    const { target: { value } } = e;
    setState((oldState) => ({ ...oldState, submitted: value }));
  }, []);

  const onKeyDown = (e: KeyboardEvent<HTMLTextAreaElement>) => {
    if (e.key === "Enter") e.preventDefault();
  };

  const onKeyUp = (e: KeyboardEvent<HTMLTextAreaElement>) => {
    const { key, target } = e;
    if (key === "Enter") {
      e.preventDefault();
      const { value } = target as HTMLTextAreaElement;
      onSubmit(value);
    }
  };

  return (
    <textarea
      style={{ width: "100%" }}
      onChange={onChange}
      onKeyUp={onKeyUp}
      onKeyDown={onKeyDown}
      name="userInput"
    />
  );
};

export default TextBox;
