using System;
using System.Linq;

namespace TripleTriad.Solver
{
	public class State
	{
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

			var newState = Clone();
			
			return newState;
		}

		public State Clone()
		{
			return new State(field, modifiers, blueHand, redHand, bluesTurn)
			       	{
			       		bluePoints = bluePoints, 
			       		redPoints = redPoints
			       	};
		}


		public byte bluePoints;
		public byte redPoints;
		private PlayField field;
		private PlayHand blueHand;
		private PlayHand redHand;
		private bool bluesTurn;
		public RuleModifier modifiers;
	}
}