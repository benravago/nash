
import java.io.Writer;

import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.PathMatcher;
import java.nio.file.Paths;

import javax.script.ScriptContext;
import javax.script.ScriptEngine;
import javax.script.SimpleScriptContext;

import nashorn.api.scripting.NashornScriptEngineFactory;

class Eval {
    public static void main(String...args) throws Exception {
        new Eval().start(args);
    }

    void start(String...args) throws Exception {
        var tests = Paths.get(args[0]);
        Files.walk(tests).filter(this::match).forEach(this::eval);
    }

    ScriptEngine engine; {
        engine = new NashornScriptEngineFactory().getScriptEngine();
        System.out.println("JS " + engine.getFactory().getEngineName()
                           + ' ' + engine.getFactory().getEngineVersion() );
    }

    PathMatcher matcher = FileSystems.getDefault().getPathMatcher("glob:**.js");

    boolean match(Path path) {
        return Files.isRegularFile(path) && matcher.matches(path);
    }

    void eval(Path path)  {
        long start = 0;
        try {
            var script = Files.readString(path);
            start = System.currentTimeMillis();
            engine.eval(script, context());
        } catch (Exception e) {
            buf.append("!! ").append(e).append('\n');
        }
        var tag = "-> "+path+' '+(System.currentTimeMillis()-start)+'\n';
        if (buf.length() > 0) {
            System.err.append(tag).append(buf).append('\n');
        } else {
            System.out.append(tag);
        }
    }

    StringBuilder buf = new StringBuilder();
    Writer stdout = writer(buf);

    ScriptContext context() {
        var c = new SimpleScriptContext();
        c.setWriter(stdout);
        buf.setLength(0);
        return c;
    }

    static Writer writer(StringBuilder sb) {
        return new Writer() {
            @Override public void write(char[] cbuf, int off, int len) { sb.append(cbuf,off,len); }
            @Override public void write(char[] cbuf) { sb.append(cbuf); }
            @Override public void write(int c) { sb.append(c); }
            @Override public void flush() {}
            @Override public void close() {}
        };
    }

}
