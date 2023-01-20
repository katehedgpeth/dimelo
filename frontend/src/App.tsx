import React, { FC } from "react";

import ListenButton from "./components/ListenButton";

import "./App.css";

const SpeechRecognition = window.SpeechRecognition
  ?? window.webkitSpeechRecognition;

const NotSupported: FC = () => (
  <>
    <h1>&#x1F62D;&#x1F62D;&#x1F62D;&#x1F62D;&#x1F62D;</h1>
    <h1> Your browser does not support Speech Recording</h1>
    <h1>&#x1F62D;&#x1F62D;&#x1F62D;&#x1F62D;&#x1F62D;</h1>
    <p>Please use one that does. We recommend Chrome or Safari.</p>
  </>
);

const Supported: FC = () => {
  const speech = new SpeechRecognition!();
  speech.lang = "es";
  speech.continuous = false;
  return (
    <div className="App">
      <h1>Say Something in Spanish!</h1>
      <ListenButton speech={speech} />
    </div>
  );
};

const App = () => (
  <div className="App">
    {SpeechRecognition
      ? <Supported />
      : <NotSupported />}
  </div>
);

export default App;
