import java.nio.*;
import java.io.*;
import java.nio.channels.*;
import java.net.*;
import java.util.*;

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
		testTagging();

		ServerSocketChannel serv = ServerSocketChannel.open();
		serv.bind(new InetSocketAddress(8080));
		for (;;) {
			testSockets(serv);
		}
	}

	private static void testSockets(ServerSocketChannel serv) throws IOException, InterruptedException {
		SocketChannel cli = serv.accept();
		cli.configureBlocking(false);
		Scanner scanner = new Scanner(cli);
		while (scanner.hasNextLine()) {
			System.out.println(scanner.nextLine());
		}
		int size = (int) new File("convector.html").length();
		ByteBuffer buf = new FileInputStream("convector.html").getChannel().map(FileChannel.MapMode.READ_ONLY, 0, size);
		while (buf.hasRemaining()) {
			buf.position(buf.position() + cli.write(buf));
		}
		cli.shutdownOutput();
	}
}
