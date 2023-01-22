export type SpeechRecognition = InstanceType<typeof window.SpeechRecognition>;

export type SpeechRecognitionEvent = InstanceType<
  typeof window.SpeechRecognitionEvent
>

export type SpeechRecognitionResult =
  InstanceType<typeof window.SpeechRecognitionAlternative>

export const UnsafeSpeechRecognition = (
  window.SpeechRecognition ?? window.webkitSpeechRecognition
);

/**
 * Note that the SpeechRecognition API does not exist on all browsers,
 * and this component is typed such that it does exist.
 * The parent component is reponsible for checking for the API and
 * deciding whether to implement this context.
 */
const unsafeSpeech: SpeechRecognition = new UnsafeSpeechRecognition!();
unsafeSpeech.lang = "es";
unsafeSpeech.continuous = false;

export default unsafeSpeech;
