using System;
using NUnit.Framework;
using TripleTriad.Solver;

namespace Tests
{
	[TestFixture]
	public class BasicTests
	{
		[Test]
		public void CardInfoLoad()
		{
			Assert.That(CardInfo.CardPool.Count, Is.EqualTo(110));
			Assert.That(CardInfo.CardPool.ContainsKey("Squall"));
			Assert.That(CardInfo.CardPool["Squall"].Up, Is.EqualTo(10));
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

		[Test]
		public void PlayCard()
		{
			var playCard = new PlayCard(CardInfo.CardPool["Squall"], true);
			Assert.That(playCard.isBlue);
			playCard.Flip();
			Assert.That(playCard.isBlue, Is.False);
		}
	}
}