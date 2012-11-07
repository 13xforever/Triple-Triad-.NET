using System;
using System.Linq;

namespace TripleTriad.Solver
{
	public class State
	{
		private readonly PlayHand blueHand;
		private readonly bool bluesTurn;
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
			if (field[x, y].Occupied)
				throw new InvalidOperationException(string.Format("Cannot play card to ({0},{1}) because this cell is already occupied.", x, y));
			PlayHand hand = bluesTurn ? blueHand : redHand;
			if (!hand.hand.Any(c => Equals(c.cardInfo, card)))
				throw new ArgumentException("There's no such a card in playing hand.", "card");
			var result = Clone();

			var playCard = hand.Extract(card);
			result.field.Put(playCard, x, y);
			return MakeMove(result, playCard, x, y);
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

		private static State MakeMove(State state, PlayCard playCard, byte x, byte y)
		{
			throw new NotImplementedException();
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