import React, { FC, useContext } from "react";
import { SentenceContext } from "../contexts/SentenceContext";

const TextBox: FC = () => {
  const { heard } = useContext(SentenceContext);
  const content = heard ? Array.from(heard.results)[0][0].transcript : "";
  return <textarea style={{ width: "100%" }} value={content} />;
};

export default TextBox;
