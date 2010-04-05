using System;
using System.Collections.Generic;
using System.Linq;

namespace TripleTriad.Solver
{
	public class PlayHand
	{
		public PlayHand(IEnumerable<PlayCard> hand, bool isBlue)
		{
			this.hand = hand.ToArray();
			if (this.hand.Length != 5) throw new ArgumentException("Invalid hand.");
			this.isBlue = isBlue;
			for (var i = 0; i < this.hand.Length; i++) this.hand[i].isBlue = isBlue;
		}

		public PlayHand Clone()
		{
			return new PlayHand(hand, isBlue);
		}

		public int RemainingCards { get { return hand.Length; } }

		public bool isBlue;
		public PlayCard[] hand;
	}
}