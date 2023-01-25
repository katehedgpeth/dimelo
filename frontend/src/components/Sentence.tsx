import React, { FC, useContext } from "react";
import WasICorrect from "./WasICorrect";
import { SentenceContext } from "../contexts/SentenceContext";
import InputForm from "./InputForm";
import NextButton from "./NextButton";

const Sentence: FC = () => {
  const {
    state: {
      sentences: { current },
      wasCorrect,
    },
  } = useContext(SentenceContext);
  if (!current) return null;

  return (
    <>
      <h1>Dímelo en Español!</h1>
      <h3>{current.text}</h3>
      <WasICorrect />
      {wasCorrect ? <NextButton /> : <InputForm />}
    </>
  );
};

export default Sentence;
