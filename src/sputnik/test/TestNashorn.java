package sputnik.test;

import java.nio.file.Path;

import sputnik.jupiter.TestFinder;

public class TestNashorn extends TestFinder {

    @Override
    protected String getPattern() {
        return NashornHarness.GLOB;
    }

    @Override
    protected void testFile(Path file) throws Throwable {
        NashornHarness.getInstance().eval(file);
    }

}
