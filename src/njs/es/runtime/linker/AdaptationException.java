package es.runtime.linker;

final class AdaptationException extends Exception {

  private final AdaptationResult adaptationResult;

  AdaptationException(AdaptationResult.Outcome outcome, String classList) {
    super(null, null, false, false);
    this.adaptationResult = new AdaptationResult(outcome, classList);
  }

  AdaptationResult getAdaptationResult() {
    return adaptationResult;
  }

}
