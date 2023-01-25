import React, { FC, useContext } from "react";
import { SentenceContext } from "../contexts/SentenceContext";

const WasICorrect: FC = () => {
  const {
    state: {
      submitted,
      sentences: { current },
      wasCorrect,
    },
  } = useContext(SentenceContext);

  if (submitted === undefined || current === undefined) return null;

  if (wasCorrect) return <h2>That&apos;s correct!!!</h2>;
  if (wasCorrect === false) {
    return (
      <div>
        <h3>We expected one of these:</h3>
        <ul>
          {current.translations.map((t) => <li key={t}>{t}</li>)}
        </ul>
      </div>
    );
  }
  return null;
};

export default WasICorrect;
