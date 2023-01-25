import React, { FC, useContext } from "react";
import { SentenceContext } from "../contexts/SentenceContext";

const NextButton: FC = () => {
  const { handlers: { onClickNext } } = useContext(SentenceContext);
  return (
    <button
      type="button"
      onClick={onClickNext}
    >
      Next
    </button>);
};

export default NextButton;
