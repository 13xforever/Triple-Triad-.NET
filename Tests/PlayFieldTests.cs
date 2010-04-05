using NUnit.Framework;
using TripleTriad.Solver;

namespace Tests
{
	[TestFixture]
	public class PlayFieldTests
	{
		[Test]
		public void PlayField()
		{
			var field = new PlayField();
			field.cell[0, 0].card = new PlayCard(CardInfo.CardPool["Squall"]);

			Assert.That(field.cell.Length, Is.EqualTo(3 * 3));
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
	}
}