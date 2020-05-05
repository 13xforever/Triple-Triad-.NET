using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

namespace TripleTriad.Logic
{
	public static class CardPool
	{
		private static readonly List<(string desc, Card card)> NameToCard = new List<(string, Card)>(128);

		static CardPool()
		{
			var assembly = Assembly.GetExecutingAssembly();
			var manifest = assembly.GetManifestResourceNames().First(m => m.EndsWith("cards.txt", StringComparison.InvariantCultureIgnoreCase));
			byte counter = 0;
			using (var stream = assembly.GetManifestResourceStream(manifest))
			using (var reader = new StreamReader(stream, Encoding.UTF8))
			{
				string l;
				while ((l = reader.ReadLine()) != null)
				{
					if (string.IsNullOrWhiteSpace(l))
						continue;

					NameToCard.Add((l, Card.Parse(counter++, l)));
				}
			}
			NameToCard.Sort();
		}

		public static int Count => NameToCard.Count;

		public static Card Find(string str)
		{
			if (str.Length < 5)
				return NameToCard.FirstOrDefault(c => c.desc.StartsWith(str, StringComparison.InvariantCultureIgnoreCase)).card;

			if (NameToCard.FirstOrDefault(c => c.card.Name.Equals(str, StringComparison.InvariantCultureIgnoreCase)).card is Card crd)
				return crd;

			return NameToCard.FirstOrDefault(c => c.desc.IndexOf(str, StringComparison.InvariantCultureIgnoreCase) != -1).card;
		}
	}
}
