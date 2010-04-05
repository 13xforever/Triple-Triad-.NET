using System;

namespace TripleTriad.Util
{
	public static class ArrayUtil
	{
		public static T[] CopyExceptElementAt<T>(this T[] array, int position)
		{
			if (array == null) throw new ArgumentNullException("array");
			if (array.Length == 0) throw new InvalidOperationException("Array is already empty.");
			if (position < 0 || position > array.Length - 1) throw new IndexOutOfRangeException();

			var result = new T[array.Length - 1];
			if (position == 0)
				Array.Copy(array, 1, result, 0, result.Length);
			else if (position == result.Length)
				Array.Copy(array, result, result.Length);
			else
			{
				Array.Copy(array, result, position);
				Array.Copy(array, position + 1, result, position, result.Length - position);
			}
			return result;
		}
	}
}