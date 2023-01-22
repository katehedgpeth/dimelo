import React, { FC, useContext } from "react";
import WasICorrect from "./WasICorrect";
import ListenButton from "./ListenButton";
import TextBox from "./TextBox";
import { SentenceContext } from "../contexts/SentenceContext";

const Sentence: FC = () => {
  const { current } = useContext(SentenceContext);
  if (!current) return null;

  return (
    <>
      <h1>Dímelo en Español!</h1>
      <h3>{current.text}</h3>
      <TextBox />
      <WasICorrect />
      <ListenButton />
    </>
  );
};

export default Sentence;
