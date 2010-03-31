using System;
using System.Collections.Generic;
using System.Linq;

namespace TripleTriad.Solver
{
	public class PlayHand
	{
		public PlayHand(){}
		public PlayHand(IEnumerable<PlayCard> hand, bool isBlue)
		{
			this.hand = new List<PlayCard>(hand);
			if (this.hand.Count != 5) throw new ArgumentException("Invalid hand.");
			this.isBlue = isBlue;
			this.hand.ForEach(c => c.isBlue = isBlue);
		}

		public int RemainingCards { get { return hand.Count; } }

		public bool isBlue;
		public List<PlayCard> hand;
	}
}