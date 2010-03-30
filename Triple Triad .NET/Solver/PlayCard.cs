using System;
using System.Collections.Generic;
using System.Linq;

namespace TripleTriad.Solver
{
	public class State
	{
		public State(){}
		public State(PlayField field, RuleModifier modifiers, PlayHand blueHand, PlayHand redHand, bool bluesTurn)
		{
			this.field = field;
			this.blueHand = blueHand;
			this.redHand = redHand;
			this.bluesTurn = bluesTurn;
			this.modifiers = modifiers;
		}

		private PlayField field;
		private PlayHand blueHand;
		private PlayHand redHand;
		private bool bluesTurn;
		public RuleModifier modifiers;
	}

	public class PlayField
	{
		
	}

	public class PlayHand
	{
		public PlayHand(){}
		public PlayHand(IEnumerable<PlayCard> hand, bool isBlue)
		{
			this.hand = new List<PlayCard>(hand.SkipWhile(c => c == null));
			if (this.hand.Count != 5 || hand.Contains(null)) throw new ArgumentException("Invalid hand.");
			this.isBlue = isBlue;
		}

		public int RemainingCards { get { return hand.Count; } }

		public bool isBlue;
		public List<PlayCard> hand;
	}

	public class PlayCard
	{
		public PlayCard(){}
		public PlayCard(CardInfo cardInfo, bool isBlue)
		{
			this.cardInfo = cardInfo;
			this.isBlue = isBlue;
			inUse = false;
		}

		public CardInfo cardInfo;
		public bool isBlue;
		public bool inUse;
	}
}