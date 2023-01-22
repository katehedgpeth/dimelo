import React, { FC, useContext } from "react";
import { SentenceContext } from "../contexts/SentenceContext";
import Sentence from "./Sentence";

const Sentences: FC = () => {
  const {
    current,
    isLoading,
    error,
  } = useContext(SentenceContext);

  if (isLoading) {
    return <h1>Fetching sentences to learn...</h1>;
  }
  if (error || (!isLoading && !current) === undefined) {
    return (
      <>
        <h1>Something went wrong</h1>
        {JSON.stringify(error)}
      </>
    );
  }

  return (
    <Sentence />
  );
};

export default Sentences;
