using NUnit.Framework;
using TripleTriad.Solver;

namespace Tests
{
	[TestFixture]
	public class StateTests
	{
		[Test]
		public void StateConstruction()
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
			State clone = state.Clone();
			Assert.That(clone.bluePoints, Is.EqualTo(4));
			clone.bluePoints--;
			Assert.That(state.bluePoints, Is.EqualTo(4));
			Assert.That(clone.bluePoints, Is.EqualTo(3));
		}
	}
}