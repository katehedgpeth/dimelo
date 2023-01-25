import React, {
  FC, useContext,
} from "react";
import { SentenceContext } from "../contexts/SentenceContext";
// import { Sentence } from "../services/sentences";

const SubmitButton: FC = () => {
  const {
    // handlers: { setState },
    state: {
      sentences: { current },
      // submitted,
    },
  } = useContext(SentenceContext);
  if (!current) return null;

  return (
    <button
      // onClick={() => submitted && checkAnswer(
      //   submitted,
      //   current.translations,
      //   setState,
      // )}
      type="submit"
    >
      Submit
    </button>
  );
};

export default SubmitButton;
