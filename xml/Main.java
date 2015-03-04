import java.nio.*;
import java.nio.channels.*;
import java.net.*;
import java.util.*;
import java.util.regex.*;

class Main {
	private static final float[] nans = new float[65536];
	
	private static void testTagging() {
		for (int i = 0; i < 65536; ++i) {
			nans[i] = Float.intBitsToFloat(0xFF80000 | i);
		}
		for (int i = 0; i < 65536; ++i) {
			assert (Float.floatToRawIntBits(nans[i]) & ~0xFF80000) == i;
		}
	}

	public static void main(String... args) throws Exception {
		ZalgoTest.main("1", "zalgo");
		SAXTest.main("1", "sax");
	}
}
