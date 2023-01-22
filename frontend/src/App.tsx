import React, { FC } from "react";
import { QueryClient, QueryClientProvider } from "react-query";

import "./App.css";
import Sentences from "./components/Sentences";
import SentenceContextProvider from "./contexts/SentenceContext";

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
      <SentenceContextProvider>
        <Sentences />
      </SentenceContextProvider>
    </div>
  );
};

const queryClient = new QueryClient();

const App = () => (
  <div className="App">
    <QueryClientProvider client={queryClient}>
      {SpeechRecognition
        ? <Supported />
        : <NotSupported />}
    </QueryClientProvider>
  </div>
);

export default App;
