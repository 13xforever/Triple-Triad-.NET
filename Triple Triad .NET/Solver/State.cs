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
			if (field.cell[x, y].Occupied)
				throw new InvalidOperationException(string.Format("Cannot play card to ({0},{1}) because this cell is already occupied.", x, y));
			PlayHand hand = bluesTurn ? blueHand : redHand;
			if (!hand.hand.Any(c => c.cardInfo == card))
				throw new ArgumentException("There's no such a card in playing hand.", "card");

			return MakeMove(Clone(), hand.Extract(card));
		}

		public State Clone()
		{
			return new State(field, modifiers, blueHand, redHand, bluesTurn)
			       	{
			       		bluePoints = bluePoints,
			       		redPoints = redPoints,
			       	};
		}

		private static State MakeMove(State state, PlayCard playCard)
		{
			throw new NotImplementedException();
		}
	}
}