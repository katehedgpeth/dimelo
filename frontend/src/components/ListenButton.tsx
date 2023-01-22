import React, { FC, useContext, useState } from "react";
import { SentenceContext } from "../contexts/SentenceContext";
import speech from "../services/speech_recognition";

const ListenButton: FC = () => {
  const { heard, setHeard } = useContext(SentenceContext);
  const [isSpeaking, setIsSpeaking] = useState(false);

  speech.addEventListener("result", (r) => setHeard(r));
  speech.addEventListener("start", () => setIsSpeaking(true));
  speech.addEventListener("end", () => setIsSpeaking(false));

  if (speech === null) return null;
  return (
    <div>
      {isSpeaking && <h3>I&apos;m Listening....</h3>}
      <div>
        <button type="button" onClick={() => speech.start()}>
          Click here to record {heard ? "again" : ""}
        </button>
      </div>
    </div>
  );
};

export default ListenButton;
