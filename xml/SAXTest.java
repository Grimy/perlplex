import javax.xml.parsers.*;
import org.xml.sax.*;
import org.xml.sax.helpers.*;
import java.io.*;
import java.nio.*;
import java.nio.channels.*;
import java.nio.charset.*;
import java.util.*;

class SAXTest extends DefaultHandler {
	/* private static PrintStream out; */
	private static MappedByteBuffer out;

	public static void main(String... args) throws Exception {
		int max = Integer.parseInt(args[0]);

		RandomAccessFile input = new RandomAccessFile("huge.svg", "rw");
		CharBuffer map = Charset.forName("ascii").decode(input.getChannel().map(FileChannel.MapMode.READ_ONLY, 0, input.length()));
		String str = map.toString();
		while (--max >= 0) {
			FileChannel chan = new RandomAccessFile(args[1], "rw").getChannel();
			out = chan.map(FileChannel.MapMode.READ_WRITE, 0, 10 << 20);
			SAXParserFactory.newInstance().newSAXParser().parse(
					new InputSource(new StringReader(str)),
					new SAXTest());
		}
		input.close();
	}

	private final void println(String str) {
		/* out.println(str); */
		out.put(str.getBytes());
		out.put((byte) '\n');
	}

	@Override
	public void startElement(final String namespace, final String local,
			final String name, final Attributes attr) {
		println("Tag: " + (namespace.isEmpty() ? "" : namespace + ":") + name);
		for (int i = 0; i < attr.getLength(); i++) {
			println("Attr: " + attr.getQName(i) + " ==> " + attr.getValue(i));
		}
	}

	@Override
	public void characters(char[] ch, int start, int length) {
		println("Text: " + new String(ch, start, length));
	}

	@Override
	public void endElement(final String namespace, final String local, final String name) {
		println("Tag: /" + (namespace.isEmpty() ? "" : namespace + ":") + name);
	}

	@Override
	public InputSource resolveEntity(final String publicId, final String systemId) {
		return new InputSource(new StringReader(""));
	}
}

