using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TripleTriad.Utils
{
	public static class Empty<T>
	{
		public static readonly T[] Array = new T[0];
	}

	public static class ArrayEx
	{
		public static T[] Exclude<T>(this T[] array, T item)
		{
			if (array.Length == 1)
				return Empty<T>.Array;

			var result = new T[array.Length - 1];
			var notSkipped = true;
			byte i1 = 0, i2=0;
			while(i1 < array.Length && i2<result.Length)
			{
				if (item.Equals(array[i1]) && notSkipped)
				{
					notSkipped = false;
					i1++;
					continue;
				}

				result[i2] = array[i1];
				i1++;
				i2++;
			}
			return result;
		}
	}
}
