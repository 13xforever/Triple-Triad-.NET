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

		[Test, ExpectedException(typeof (IndexOutOfRangeException))]
		public void ArrayUtilArgumentException()
		{
			(new[] {0}).CopyExceptElementAt(1);
		}

		[Test, ExpectedException(typeof (ArgumentNullException))]
		public void ArrayUtilNullException()
		{
			((int[]) null).CopyExceptElementAt(1);
		}

		[Test, ExpectedException(typeof (InvalidOperationException))]
		public void ArrayUtilOnEmptyArray()
		{
			(new int[] {}).CopyExceptElementAt(1);
		}

		[Test, ExpectedException(typeof (IndexOutOfRangeException))]
		public void ArrayUtilWithNegativeArgument()
		{
			(new[] {0}).CopyExceptElementAt(-1);
		}
	}
}