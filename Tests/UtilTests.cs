using System;
using NUnit.Framework;
using TripleTriad.Util;

namespace Tests
{
	[TestFixture]
	public class UtilTests
	{
		[Test]
		public void ArrayUtil()
		{
			var testArray = new[] {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
			Assert.That(testArray.CopyExceptElementAt(0), Is.EqualTo(new[] {1, 2, 3, 4, 5, 6, 7, 8, 9}));
			Assert.That(testArray.CopyExceptElementAt(1), Is.EqualTo(new[] {0, 2, 3, 4, 5, 6, 7, 8, 9}));
			Assert.That(testArray.CopyExceptElementAt(7), Is.EqualTo(new[] {0, 1, 2, 3, 4, 5, 6, 8, 9}));
			Assert.That(testArray.CopyExceptElementAt(9), Is.EqualTo(new[] {0, 1, 2, 3, 4, 5, 6, 7, 8}));
		}

		[Test]
		public void ArrayUtilArgumentException()
		{
			Assert.That(() => new[] {0}.CopyExceptElementAt(1), Throws.InstanceOf<IndexOutOfRangeException>());
		}

		[Test]
		public void ArrayUtilNullException()
		{
			Assert.That(() => ((int[])null).CopyExceptElementAt(1), Throws.InstanceOf<ArgumentNullException>());
		}

		[Test]
		public void ArrayUtilOnEmptyArray()
		{
			Assert.That(() => new int[0].CopyExceptElementAt(1), Throws.InstanceOf<InvalidOperationException>());
		}

		[Test]
		public void ArrayUtilWithNegativeArgument()
		{
			Assert.That(() => new[] { 0 }.CopyExceptElementAt(-1), Throws.InstanceOf<IndexOutOfRangeException>());
		}
	}
}