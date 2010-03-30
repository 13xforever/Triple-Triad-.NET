using System;
using System.Collections.Generic;

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
		public PlayHand(List<PlayCard> hand)
		{
			if (hand.Count != 5 || hand.Contains(null)) throw new ArgumentException("Invalid hand.");
			this.hand = hand;
		}

		public int RemainingCards { get { return hand.Count; } }

		public bool isBlue;
		public List<PlayCard> hand;
	}

	public class PlayCard
	{
		public CardInfo cardInfo;
		public bool inUse;
		public bool isBlue;
	}
}