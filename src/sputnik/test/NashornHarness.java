package sputnik.test;

import java.io.Writer;

import java.nio.file.Path;
import java.nio.file.Files;

import javax.script.ScriptEngine;
import javax.script.ScriptContext;
import javax.script.SimpleScriptContext;

import nashorn.api.scripting.NashornScriptEngineFactory;
import sputnik.jupiter.Fail;

public class NashornHarness {

    private NashornHarness() {}

    public static NashornHarness getInstance() {
        return Singleton.INSTANCE;
    }

    private static class Singleton {
        static final NashornHarness INSTANCE = new NashornHarness();
    }

    final static String GLOB = "**.js";

    ScriptEngine engine = new NashornScriptEngineFactory().getScriptEngine();

    ScriptContext context() {
        var c = new SimpleScriptContext();
        c.setErrorWriter(stderr);
        buf.setLength(0);
        return c;
    }

    // synchronized 
    public void eval(Path path) throws Throwable {       
        System.err.print(path.toString());
        long start = 0;
        try {
            var script = Files.readString(path);
            start = System.currentTimeMillis();
            engine.eval(script, context());
        } catch (Throwable t) {
            buf.append("!! ").append(t).append('\n');
        }
        System.err.println(" "+(System.currentTimeMillis()-start));
        if (buf.length() > 0) throw new Fail(buf.toString());
    }
    
    StringBuilder buf = new StringBuilder();
    Writer stderr = writer(buf);
    
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
