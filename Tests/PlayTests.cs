using NUnit.Framework;
using TripleTriad.Logic;

namespace Tests
{
	[TestFixture]
	public class PlayTests
	{
		private readonly PlayCard[] pinkHand =
		{
			new PlayCard(CardPool.Find("Shumi Tribe"), Color.Pink),
			new PlayCard(CardPool.Find("BGH251F2"), Color.Pink),
			new PlayCard(CardPool.Find("Squall"), Color.Pink),
			new PlayCard(CardPool.Find("Fastitocalon"), Color.Pink),
			new PlayCard(CardPool.Find("Pandemona"), Color.Pink),
		};

		private readonly PlayCard[] blueHand =
		{
			new PlayCard(CardPool.Find("Quistis"), Color.Blue),
			new PlayCard(CardPool.Find("Granaldo"), Color.Blue),
			new PlayCard(CardPool.Find("Blue Dragon"), Color.Blue),
			new PlayCard(CardPool.Find("Oilboyle"), Color.Blue),
			new PlayCard(CardPool.Find("Tiamat"), Color.Blue),
		};

		[Test]
		public void SimpleGame()
		{
			var state = new State{Field = Field.Default, BlueHand = blueHand, PinkHand = pinkHand};
			var rules = new Rules();
			/*
			 * 0 1 2
			 * 3 4 5
			 * 6 7 8
			 */
			//Turn 1
			state = rules.Play(state, state.BlueHand[0], 0);
			Assert.That(state.BlueHand.Length, Is.EqualTo(4));

			//Turn 2
			state = rules.Play(state, state.PinkHand[0], 1);
			Assert.That(state.PinkHand.Length, Is.EqualTo(4));

			//Turn 3
			state = rules.Play(state, state.BlueHand[0], 2);
			Assert.That(state.BlueHand.Length, Is.EqualTo(3));

			//Turn 4
			state = rules.Play(state, state.PinkHand[0], 3);
			Assert.That(state.PinkHand.Length, Is.EqualTo(3));

			//Turn 5
			state = rules.Play(state, state.BlueHand[0], 4);
			Assert.That(state.BlueHand.Length, Is.EqualTo(2));

			//Turn 6
			state = rules.Play(state, state.PinkHand[0], 5);
			Assert.That(state.PinkHand.Length, Is.EqualTo(2));

			//Turn 7
			state = rules.Play(state, state.BlueHand[0], 6);
			Assert.That(state.BlueHand.Length, Is.EqualTo(1));

			//Turn 8
			state = rules.Play(state, state.PinkHand[0], 7);
			Assert.That(state.PinkHand.Length, Is.EqualTo(1));

			//Turn 9
			state = rules.Play(state, state.BlueHand[0], 8);
			Assert.That(state.BlueHand.Length, Is.EqualTo(0));

			Assert.That(state.IsFinished);
			Assert.That(state.PinkScore, Is.EqualTo(6));
		}

		[Test]
		public void FindMoveTest()
		{
			var state = new State { Field = Field.Default, BlueHand = blueHand, PinkHand = pinkHand };
			var rules = new Rules();

			var (card, position, stats) = rules.FindBestMove(state, Color.Pink);
			Assert.That(card.Name, Is.EqualTo("BGH251F2"));
			Assert.That(position, Is.EqualTo(8));
			Assert.That(stats.Wins, Is.EqualTo(0));
			Assert.That(stats.Draws, Is.EqualTo(0));
			Assert.That(stats.Defeats, Is.EqualTo(0));
		}
	}
}