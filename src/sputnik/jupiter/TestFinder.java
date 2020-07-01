package sputnik.jupiter;

import java.io.IOException;
import java.io.UncheckedIOException;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;

import java.nio.file.FileSystems;
import java.nio.file.PathMatcher;

import java.util.Objects;
import java.util.stream.Stream;

import org.junit.jupiter.api.DynamicContainer;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.TestFactory;

// For ConsoleLauncher:
//   Test/TestFactory class names should follow
//   the default pattern [^(Test.*|.+[.$]Test.*|.*Tests?)$]
//   or be specified via --include-classname

public class TestFinder {

    @TestFactory
    DynamicContainer[] testFactory() {
        return new DynamicContainer[] {
            testSuite( directory(getRoot()), matcher(getPattern()) )
        };
    }

    DynamicContainer testSuite(Path dir, PathMatcher glob) {
        return DynamicContainer.dynamicContainer(
            dir.getFileName().toString(),
            list(dir).map(path ->
                Files.isRegularFile(path) && glob.matches(path) ? testCase(path) :
                Files.isDirectory(path) ? testSuite(path,glob) :
                null ).filter(Objects::nonNull)
        );
    }

    DynamicTest testCase(Path file) {
        return DynamicTest.dynamicTest(
            file.getFileName().toString(),
            () -> testFile(file)
        );
    }

    static PathMatcher matcher(String syntaxAndPattern) {
        if ( !syntaxAndPattern.startsWith("glob:") && !syntaxAndPattern.startsWith("regex:") ) {
            syntaxAndPattern = "glob:"+syntaxAndPattern;
        }
        return FileSystems.getDefault().getPathMatcher(syntaxAndPattern);
    }

    static Path directory(String path) {
        var dir = Paths.get(path);
        if (Files.isDirectory(dir)) {
            return dir;
        }
        throw new IllegalArgumentException("not a directory or file: "+path);
    }

    static Stream<Path> list(Path path) {
        try { return Files.list(path); }
        catch (IOException e) { throw new UncheckedIOException(e); }
    }

    protected String getRoot() {
        return System.getProperty("test.root", "./tests" );
    }

    protected String getPattern() {
        return System.getProperty("test.pattern", "**.*" );
    }

    protected void testFile(Path file) throws Throwable {
        System.err.println("test "+file+' '+Files.size(file));
    }

}
/*
   TODO:

   -Dtest.root='./test'
   -Dtest.pattern='*.js'
   -Dtest.class=simple.Case#test

   class Case {
     void test(Path path) throws Throwable { ... }
   }
*/
