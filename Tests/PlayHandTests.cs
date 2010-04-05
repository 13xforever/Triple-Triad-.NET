using NUnit.Framework;
using TripleTriad.Solver;

namespace Tests
{
	[TestFixture]
	public class PlayHandTests
	{
		private static PlayHand GetTestHand()
		{
			return new PlayHand(new[]
			                    	{
			                    		new PlayCard(CardInfo.CardPool["Squall"]),
			                    		new PlayCard(CardInfo.CardPool["Krysta"]),
			                    		new PlayCard(CardInfo.CardPool["Wendigo"]),
			                    		new PlayCard(CardInfo.CardPool["Behemoth"]),
			                    		new PlayCard(CardInfo.CardPool["Wendigo"]),
			                    	}, true);
		}

		[Test]
		public void Extract()
		{
			PlayHand hand = GetTestHand();

			Assert.That(hand.RemainingCards, Is.EqualTo(5));
			Assert.That(hand.hand[2].cardInfo, Is.EqualTo(CardInfo.CardPool["Wendigo"]));
			Assert.That(hand.hand[2].inUse, Is.False);

			PlayCard card = hand.Extract(CardInfo.CardPool["Wendigo"]);
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

		[Test]
		public void PlayHand()
		{
			var hand = GetTestHand();
			Assert.That(hand.RemainingCards, Is.EqualTo(5));

			var arrayOfStructs = new[] {new PlayCard(CardInfo.CardPool["Krysta"])};
			Assert.That(arrayOfStructs[0].isBlue, Is.False);
			arrayOfStructs[0].Flip();
			Assert.That(arrayOfStructs[0].isBlue);

			PlayHand clonedHand = hand.Clone();
			Assert.That(clonedHand.hand[0].isBlue, Is.EqualTo(hand.hand[0].isBlue));

			clonedHand.hand[0].Flip();
			Assert.That(clonedHand.hand[0].isBlue, Is.Not.EqualTo(hand.hand[0].isBlue));
		}
	}
}