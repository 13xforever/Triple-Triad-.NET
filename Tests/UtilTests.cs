using NUnit.Framework;
using TripleTriad.Utils;

namespace Tests
{
	[TestFixture]
	public class UtilTests
	{
		[Test]
		public void ArrayUtil()
		{
			var testArray = new[] {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
			Assert.That(testArray.Exclude(0), Is.EqualTo(new[] {1, 2, 3, 4, 5, 6, 7, 8, 9}));
			Assert.That(testArray.Exclude(1), Is.EqualTo(new[] {0, 2, 3, 4, 5, 6, 7, 8, 9}));
			Assert.That(testArray.Exclude(7), Is.EqualTo(new[] {0, 1, 2, 3, 4, 5, 6, 8, 9}));
			Assert.That(testArray.Exclude(9), Is.EqualTo(new[] {0, 1, 2, 3, 4, 5, 6, 7, 8}));
		}
	}
}