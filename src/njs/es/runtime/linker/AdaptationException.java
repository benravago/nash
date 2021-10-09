package es.runtime.linker;

@SuppressWarnings("serial")
final class AdaptationException extends Exception {

  private final AdaptationResult adaptationResult;

  AdaptationException(final AdaptationResult.Outcome outcome, final String classList) {
    super(null, null, false, false);
    this.adaptationResult = new AdaptationResult(outcome, classList);
  }

  AdaptationResult getAdaptationResult() {
    return adaptationResult;
  }
}
