import React, { FC, useContext, useState } from "react";
import { SentenceContext } from "../contexts/SentenceContext";
import speech from "../services/speech_recognition";

const ListenButton: FC = () => {
  const {
    handlers: { setState },
    state: { submitted },
  } = useContext(SentenceContext);
  const [isSpeaking, setIsSpeaking] = useState(false);

  speech.addEventListener("result", (r) => (
    setState((oldState) => ({
      ...oldState,
      submitted: r.results[0][0].transcript,
    }))
  ));
  speech.addEventListener("start", () => setIsSpeaking(true));
  speech.addEventListener("end", () => setIsSpeaking(false));

  if (speech === null) return null;
  return (
    <div>
      {isSpeaking && <h3>I&apos;m Listening....</h3>}
      <div>
        <button type="button" onClick={() => speech.start()}>
          Click here to record {submitted ? "again" : ""}
        </button>
      </div>
    </div>
  );
};

export default ListenButton;
