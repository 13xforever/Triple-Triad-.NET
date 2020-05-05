using System;
using NUnit.Framework;
using TripleTriad.Logic;

namespace Tests
{
	[TestFixture]
	public class BasicTests
	{
		[Test]
		public void CardInfoLoad()
		{
			Assert.That(CardPool.Count, Is.EqualTo(110));
			Assert.That(CardPool.Find("Squall"), Is.Not.Null);
			Assert.That(CardPool.Find("Squall").Up, Is.EqualTo(10));
		}

		[Test]
		public void EnumParse()
		{
			Element e;
			Enum.TryParse("Water", out e);
			Assert.That(e, Is.EqualTo(Element.Water));
			Enum.TryParse("Thunder", out e);
			Assert.That(e, Is.EqualTo(Element.Thunder));
			Enum.TryParse("Poison", out e);
			Assert.That(e, Is.Not.EqualTo(Element.Holy));
		}
	}
}