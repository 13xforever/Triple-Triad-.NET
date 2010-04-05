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

		[Test]
		public void PlayField()
		{
			var field = new PlayField();
			field.cell[0, 0].card = new PlayCard(CardInfo.CardPool["Squall"]);

			Assert.That(field.cell.Length, Is.EqualTo(3*3));
			Assert.That(field.cell.GetLength(0), Is.EqualTo(3));

			Assert.That(field.cell[0, 0].left, Is.EqualTo(10));
			Assert.That(field.cell[0, 0].up, Is.EqualTo(10));
			Assert.That(field.cell[0, 0].right, Is.EqualTo(0));
			Assert.That(field.cell[0, 0].down, Is.EqualTo(0));

			PlayField field2 = field.Clone();
			Assert.That(field.cell[0, 0].card.cardInfo, Is.EqualTo(field2.cell[0, 0].card.cardInfo));
			Assert.That(field.cell[0, 0].card.isBlue, Is.EqualTo(field2.cell[0, 0].card.isBlue));

			field2.cell[0, 0].card.Flip();
			Assert.That(field.cell[0, 0].card.isBlue, Is.Not.EqualTo(field2.cell[0, 0].card.isBlue));

			field2.cell[0, 0].card = new PlayCard(CardInfo.CardPool["Bomb"]);
			Assert.That(field.cell[0, 0].card.cardInfo, Is.Not.EqualTo(field2.cell[0, 0].card.cardInfo));
		}

		[Test]
		public void PlayFieldConstruction()
		{
			var blueHand = new PlayHand(new[]
			                            	{
			                            		new PlayCard(CardInfo.CardPool["Squall"]),
			                            		new PlayCard(CardInfo.CardPool["Krysta"]),
			                            		new PlayCard(CardInfo.CardPool["Wendigo"]),
			                            		new PlayCard(CardInfo.CardPool["Behemoth"]),
			                            		new PlayCard(CardInfo.CardPool["Tonberry"]),
			                            	}, true);
			var redHand = new PlayHand(new[]
			                           	{
			                           		new PlayCard(CardInfo.CardPool["Torama"]),
			                           		new PlayCard(CardInfo.CardPool["Gerogero"]),
			                           		new PlayCard(CardInfo.CardPool["Buel"]),
			                           		new PlayCard(CardInfo.CardPool["Bomb"]),
			                           		new PlayCard(CardInfo.CardPool["Diablos"]),
			                           	}, false);
			var state = new State(new PlayField(), RuleModifier.None, blueHand, redHand, true);

			Assert.That(state.bluePoints, Is.EqualTo(5));
			state.bluePoints--;
			Assert.That(state.bluePoints, Is.EqualTo(4));
			var clone = state.Clone();
			Assert.That(clone.bluePoints, Is.EqualTo(4));
			clone.bluePoints--;
			Assert.That(state.bluePoints, Is.EqualTo(4));
			Assert.That(clone.bluePoints, Is.EqualTo(3));
		}

		[Test]
		public void PlayHand()
		{
			var hand = new PlayHand(new[]
			                        	{
			                        		new PlayCard(CardInfo.CardPool["Squall"]),
			                        		new PlayCard(CardInfo.CardPool["Krysta"]),
			                        		new PlayCard(CardInfo.CardPool["Wendigo"]),
			                        		new PlayCard(CardInfo.CardPool["Behemoth"]),
			                        		new PlayCard(CardInfo.CardPool["Wendigo"]),
			                        	}, true);
			Assert.That(hand.RemainingCards, Is.EqualTo(5));

			var arrayOfStructs = new[] {new PlayCard(CardInfo.CardPool["Krysta"])};
			Assert.That(arrayOfStructs[0].isBlue, Is.False);
			arrayOfStructs[0].Flip();
			Assert.That(arrayOfStructs[0].isBlue);

			PlayHand clonedHand = hand.Clone();
			Assert.That(clonedHand.hand[0].isBlue, Is.EqualTo(hand.hand[0].isBlue));

			clonedHand.hand[0].Flip();
			Assert.That(clonedHand.hand[0].isBlue, Is.Not.EqualTo(hand.hand[0].isBlue));

			Assert.That(hand.RemainingCards, Is.EqualTo(5));
			Assert.That(hand.hand[2].cardInfo, Is.EqualTo(CardInfo.CardPool["Wendigo"]));
			Assert.That(hand.hand[2].inUse, Is.False);

			var card = hand.Extract(CardInfo.CardPool["Wendigo"]);
			Assert.That(hand.RemainingCards, Is.EqualTo(4));
			Assert.That(hand.hand[2].cardInfo, Is.EqualTo(CardInfo.CardPool["Behemoth"]));
			Assert.That(card.cardInfo, Is.EqualTo(CardInfo.CardPool["Wendigo"]));
			Assert.That(card.inUse);
			card = hand.Extract(1);
			Assert.That(hand.RemainingCards, Is.EqualTo(3));
			Assert.That(hand.hand[2].cardInfo, Is.EqualTo(CardInfo.CardPool["Wendigo"]));
			Assert.That(card.cardInfo, Is.EqualTo(CardInfo.CardPool["Krysta"]));
			Assert.That(card.inUse);
		}
	}
}