using System;
using System.Linq;

namespace TripleTriad.Solver
{
	public class State
	{
		private readonly PlayHand blueHand;
		private bool bluesTurn;
		private readonly PlayField field;
		private readonly PlayHand redHand;
		public byte bluePoints;
		public RuleModifier modifiers;
		public byte redPoints;

		public State(PlayField field, RuleModifier modifiers, PlayHand blueHand, PlayHand redHand, bool bluesTurn)
		{
			this.field = field.Clone();
			this.blueHand = blueHand.Clone();
			this.redHand = redHand.Clone();
			this.bluesTurn = bluesTurn;
			this.modifiers = modifiers;
			bluePoints = 5;
			redPoints = 5;
		}

		public State PlayCard(CardInfo card, byte x, byte y)
		{
			if (field.cell[x, y].Occupied)
				throw new InvalidOperationException(string.Format("Cannot play card to ({0},{1}) because this cell is already occupied.", x, y));
			PlayHand hand = bluesTurn ? blueHand : redHand;
			if (!hand.hand.Any(c => Equals(c.cardInfo, card)))
				throw new ArgumentException("There's no such a card in playing hand.", "card");

			var result = Clone();
			hand = result.bluesTurn ? result.blueHand : result.redHand;
			var playCard = hand.Extract(card);
			result.field.Put(playCard, x, y);
			result.bluesTurn = !result.bluesTurn;
			return UpdateStateAfterMove(result, x, y);
		}

		public State Clone()
		{
			return new State(field, modifiers, blueHand, redHand, bluesTurn)
				       {
					       bluePoints = bluePoints,
					       redPoints = redPoints,
				       };
		}

		public bool GameIsOver { get { return blueHand.RemainingCards + redHand.RemainingCards == 1; } }
		public int Balance { get { return redPoints - bluePoints; } }

		private State UpdateStateAfterMove(State newState, byte x, byte y)
		{
			var sameConnections = 0;
			var cell = newState.field.cell[x, y];
			if (cell.up == cell.card.cardInfo.Up && y > 0) sameConnections++;
			if (cell.down == cell.card.cardInfo.Down && y < PlayField.maxCoord) sameConnections++;
			if (cell.left == cell.card.cardInfo.Left && x>0) sameConnections++;
			if (cell.right == cell.card.cardInfo.Right && x < PlayField.maxCoord) sameConnections++;

			if (sameConnections > 1)
			{
				if (cell.up == cell.card.cardInfo.Up && y > 0) newState.field.cell[x, y - 1].card.Flip();
				if (cell.down == cell.card.cardInfo.Down && y < PlayField.maxCoord) newState.field.cell[x, y + 1].card.Flip();
				if (cell.left == cell.card.cardInfo.Left && x > 0) newState.field.cell[x - 1, y].card.Flip();
				if (cell.right == cell.card.cardInfo.Right && x < PlayField.maxCoord) newState.field.cell[x + 1, y].card.Flip();
			}

			return newState;
		}

		public override bool Equals(object obj)
		{
			if (ReferenceEquals(null, obj)) return false;
			if (ReferenceEquals(this, obj)) return true;
			if (obj.GetType() != GetType()) return false;
			return Equals((State) obj);
		}

		protected bool Equals(State other)
		{
			return blueHand.Equals(other.blueHand) &&
			       bluesTurn.Equals(other.bluesTurn) &&
			       field.Equals(other.field) &&
			       redHand.Equals(other.redHand) &&
			       modifiers.Equals(other.modifiers);
		}

		public override int GetHashCode()
		{
			unchecked
			{
				int hashCode = blueHand.GetHashCode();
				hashCode = (hashCode * 397) ^ bluesTurn.GetHashCode();
				hashCode = (hashCode * 397) ^ field.GetHashCode();
				hashCode = (hashCode * 397) ^ redHand.GetHashCode();
				hashCode = (hashCode * 397) ^ modifiers.GetHashCode();
				return hashCode;
			}
		}
	}
}