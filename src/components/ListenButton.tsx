import React, { FC, useState } from "react";

type SR = InstanceType<typeof window.SpeechRecognition>;
type SpeechRecognitionEvent = InstanceType<typeof window.SpeechRecognitionEvent>

const onClickButton = (speech: SR) => () => {
  speech.start();
};

const Result: FC<{
  result: InstanceType<typeof window.SpeechRecognitionAlternative>
}> = ({
  result: { transcript, confidence },
}) => (<>
  <p>{transcript}</p>
  <small><i>{(confidence * 100).toFixed(2)}% Confidence</i></small>
</>); // eslint-disable-line react/jsx-closing-tag-location

const ShowResults: FC<{ results: SpeechRecognitionEvent }> = ({ results }) => {
  const { results: [result] } = results;
  return (
    <div>
      <h3>Here is what we just heard:</h3>
      {Array.from(result).map((r) => <Result result={r} key={r.transcript} />)}
    </div>
  );
};

const ListenButton: FC<{ speech: SR }> = ({ speech }) => {
  const [results, setResults] = useState<
    SpeechRecognitionEvent | null
  >(null);

  speech.addEventListener("result", (r) => setResults(r));

  if (speech === null) return null;
  return (
    <div>
      {results && <ShowResults results={results} />}
      <div>
        <button type="button" onClick={onClickButton(speech)}>
          Click here to record {results ? "again" : ""}
        </button>
      </div>
    </div>
  );
};

export default ListenButton;
