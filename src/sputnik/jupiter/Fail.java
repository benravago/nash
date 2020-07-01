package sputnik.jupiter;

public class Fail extends RuntimeException {
    public Fail(String message) { super(message,null,false,false); }
    private static final long serialVersionUID = 1L;
}
