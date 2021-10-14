package nash.scripting;

import java.io.CharArrayReader;
import java.io.IOException;
import java.io.Reader;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.Objects;
import es.runtime.Source;

/**
 * A Reader that reads from a URL.
 *
 * Used to make sure that the reader reads content from given URL and can be trusted to do so.
 */
public final class URLReader extends Reader {

  // underlying URL
  private final URL url;
  // Charset used to convert
  private final Charset cs;

  // lazily initialized underlying reader for URL
  private Reader reader;

  /**
   * Constructor
   *
   * @param url URL for this URLReader
   * @throws NullPointerException if url is null
   */
  public URLReader(URL url) {
    this(url, (Charset) null);
  }

  /**
   * Constructor
   *
   * @param url URL for this URLReader
   * @param charsetName  Name of the Charset used to convert bytes to chars
   * @throws NullPointerException if url is null
   */
  public URLReader(URL url, String charsetName) {
    this(url, Charset.forName(charsetName));
  }

  /**
   * Constructor
   *
   * @param url URL for this URLReader
   * @param cs  Charset used to convert bytes to chars
   * @throws NullPointerException if url is null
   */
  public URLReader(URL url, Charset cs) {
    this.url = Objects.requireNonNull(url);
    this.cs = cs;
  }

  @Override
  public int read(char cbuf[], int off, int len) throws IOException {
    return getReader().read(cbuf, off, len);
  }

  @Override
  public void close() throws IOException {
    getReader().close();
  }

  /**
   * URL of this reader
   *
   * @return the URL from which this reader reads.
   */
  public URL getURL() {
    return url;
  }

  /**
   * Charset used by this reader
   *
   * @return the Charset used to convert bytes to chars
   */
  public Charset getCharset() {
    return cs;
  }

  // lazily initialize char array reader using URL content
  private Reader getReader() throws IOException {
    synchronized (lock) {
      if (reader == null) {
        reader = new CharArrayReader(Source.readFully(url, cs));
      }
    }

    return reader;
  }

}
