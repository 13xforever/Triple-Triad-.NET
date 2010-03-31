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
		public void PlayCard()
		{
			var playCard = new PlayCard(CardInfo.CardPool["Squall"], true);
			Assert.That(playCard.isBlue);
			playCard.Flip();
			Assert.That(!playCard.isBlue);
		}

		[Test]
		public void PlayHand()
		{
			PlayHand hand = new PlayHand(new[]
			                  	{
			                  		new PlayCard(CardInfo.CardPool["Squall"]),
			                  		new PlayCard(CardInfo.CardPool["Krysta"]),
			                  		new PlayCard(CardInfo.CardPool["Wendigo"]),
			                  		new PlayCard(CardInfo.CardPool["Behemoth"]),
			                  		new PlayCard(CardInfo.CardPool["Tonberry"]),
			                  	}, true);
			Assert.That(hand.hand.Count, Is.EqualTo(5));
		}

		[Test]
		public void PlayField()
		{
			var field = new PlayField();
			field.cell[0, 0].card = new PlayCard(CardInfo.CardPool["Squall"]);

			Assert.That(field.cell.Length, Is.EqualTo(3*3));
			Assert.That(field.cell.GetLength(0), Is.EqualTo(3));

			Assert.That(field.cell[0,0].left, Is.EqualTo(10));
			Assert.That(field.cell[0,0].up, Is.EqualTo(10));
			Assert.That(field.cell[0,0].right, Is.EqualTo(0));
			Assert.That(field.cell[0,0].down, Is.EqualTo(0));

			var field2 = field.Clone();
			Assert.That(field.cell[0, 0].card.cardInfo, Is.EqualTo(field2.cell[0, 0].card.cardInfo));
			Assert.That(field.cell[0, 0].card.isBlue, Is.EqualTo(field2.cell[0, 0].card.isBlue));

			((PlayCard)field2.cell[0, 0].card).Flip();
			Assert.That(field.cell[0, 0].card.isBlue, Is.Not.EqualTo(field2.cell[0, 0].card.isBlue));

			field2.cell[0, 0].card = new PlayCard(CardInfo.CardPool["Bomb"]);
			Assert.That(field.cell[0, 0].card.cardInfo, Is.Not.EqualTo(field2.cell[0, 0].card.cardInfo));

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
