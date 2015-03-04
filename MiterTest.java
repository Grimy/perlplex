import java.awt.BasicStroke;
import java.awt.geom.Path2D;
import java.awt.geom.PathIterator;
import java.util.function.DoublePredicate;

public class Test {
	private static final Path2D path = new Path2D.Float();

	public static void main(String... args) {
		for (int i = 1; i < 3000; ++i) {
			path.reset();
			path.moveTo(0, 0);
			path.lineTo(i, 3);
			path.lineTo(0, 4);
			float limit = (float) bisect(1, 2 * i, Test::isMiter);
			assert !isMiter(limit);
			assert isMiter(Math.nextUp(limit));
			double sqrt = Math.sqrt(1 + i * i);
			// System.out.println(i + ": " + limit);
			// System.out.printf("%8.8f < %8.8f < %8.8f\n", limit, sqrt, Math.nextUp(limit));
			System.out.println(651.89898989898989 / limit);
		}
	}

	private static double bisect(double min, double max, DoublePredicate p) {
		if ((float) max == Math.nextUp((float) min)) {
			return min;
		}
		double mean = (min + max) / 2;
		return p.test(mean) ? bisect(min, mean, p) : bisect(mean, max, p);
	}

	private static boolean isMiter(double miterLimit) {
		PathIterator itr = new BasicStroke(0, BasicStroke.CAP_BUTT, BasicStroke.JOIN_MITER, (float) miterLimit).createStrokedShape(path).getPathIterator(null);
		int i;
		for (i = 0; !itr.isDone(); ++i, itr.next());
		assert i == 11 || i == 12;
		return i == 12;
	}
}
