using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using TripleTriad.Solver;

namespace Tests
{
	[TestFixture]
	public class BasicTests
	{
		[Test]
		public void EnumParse()
		{
			Element e;
			Element.TryParse("Water", out e);
			Assert.That(e, Is.EqualTo(Element.Water));
			Enum.TryParse("Thunder", out e);
			Assert.That(e, Is.EqualTo(Element.Thunder));
			Enum.TryParse("Poison", out e);
			Assert.That(e, Is.Not.EqualTo(Element.Holy));
		}

		[Test]
		public void CardInfoLoad()
		{
			Assert.That(CardInfo.CardPool.Count, Is.EqualTo(110));
			Assert.That(CardInfo.CardPool.ContainsKey("Squall"));
			Assert.That(CardInfo.CardPool["Squall"].Up, Is.EqualTo(10));
		}
	}
}
