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

		[Test]
		public void PlayHand()
		{

			PlayCard[] hand = new[]
			                  	{
			                  		null,
			                  		new PlayCard(CardInfo.CardPool["Squall"]),
									null, null,
			                  		new PlayCard(CardInfo.CardPool["Krysta"]),
			                  		new PlayCard(CardInfo.CardPool["Wendigo"]),
			                  		new PlayCard(CardInfo.CardPool["Behemoth"]),
			                  		new PlayCard(CardInfo.CardPool["Tonberry"]),
			                  	};
			Assert.That(new PlayHand(hand, true).RemainingCards, Is.EqualTo(5));
		}
		[Test]
		public void PlayFieldConstruction()
		{
			PlayHand blueHand = new PlayHand(new[]
			                  	{
			                  		new PlayCard(CardInfo.CardPool["Squall"]),
			                  		new PlayCard(CardInfo.CardPool["Krysta"]),
			                  		new PlayCard(CardInfo.CardPool["Wendigo"]),
			                  		new PlayCard(CardInfo.CardPool["Behemoth"]),
			                  		new PlayCard(CardInfo.CardPool["Tonberry"]),
			                  	}, true);
			PlayHand redHand = new PlayHand(new[]
			                  	{
			                  		new PlayCard(CardInfo.CardPool["Torama"]),
			                  		new PlayCard(CardInfo.CardPool["Gerogero"]),
			                  		new PlayCard(CardInfo.CardPool["Buel"]),
			                  		new PlayCard(CardInfo.CardPool["Bomb"]),
			                  		new PlayCard(CardInfo.CardPool["Diablos"]),
			                  	}, false);
			State state = new State(new PlayField(), RuleModifier.None, blueHand, redHand, true);
		}
	}
}
