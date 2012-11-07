using NUnit.Framework;
using TripleTriad.Solver;

namespace Tests
{
	[TestFixture]
	public class PlayTests
	{
		[Test]
		public void SimpleGame()
		{
			var redHand = new PlayHand(new[]
			                           	{
			                           		new PlayCard(CardInfo.CardPool["Shumi Tribe"]),
			                           		new PlayCard(CardInfo.CardPool["BGH251F2"]),
			                           		new PlayCard(CardInfo.CardPool["Squall"]),
			                           		new PlayCard(CardInfo.CardPool["Fastitocalon"]),
			                           		new PlayCard(CardInfo.CardPool["Pandemona"]),
			                           	}, false);
			var blueHand = new PlayHand(new[]
			                            	{
			                            		new PlayCard(CardInfo.CardPool["Quistis"]),
			                            		new PlayCard(CardInfo.CardPool["Granaldo"]),
			                            		new PlayCard(CardInfo.CardPool["Blue Dragon"]),
			                            		new PlayCard(CardInfo.CardPool["Oilboyle"]),
			                            		new PlayCard(CardInfo.CardPool["Tiamat"]),
			                            	}, true);
			var state = new State(new PlayField(), RuleModifier.None, blueHand, redHand, true);

			//Turn 1
			var playCard = blueHand.hand[0].cardInfo;
			state = state.PlayCard(playCard, 1, 1);

			//Turn 2
			playCard = redHand.hand[0].cardInfo;
			state = state.PlayCard(playCard, 2, 1);

			//Turn 3
			playCard = blueHand.hand[0].cardInfo;
			state = state.PlayCard(playCard, 3, 1);

			//Turn 4
			playCard = redHand.hand[0].cardInfo;
			state = state.PlayCard(playCard, 1, 2);

			//Turn 5
			playCard = blueHand.hand[0].cardInfo;
			state = state.PlayCard(playCard, 2, 2);

			//Turn 6
			playCard = redHand.hand[0].cardInfo;
			state = state.PlayCard(playCard, 3, 2);

			//Turn 7
			playCard = blueHand.hand[0].cardInfo;
			state = state.PlayCard(playCard, 1, 3);

			//Turn 8
			playCard = redHand.hand[0].cardInfo;
			state = state.PlayCard(playCard, 2, 3);

			//Turn 9
			playCard = blueHand.hand[0].cardInfo;
			state = state.PlayCard(playCard, 3, 3);

			Assert.That(state.GameIsOver);
			Assert.That(state.Balance, Is.EqualTo(2));
		}
	}
}