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
			this.hand = new List<PlayCard>(hand.Where(c => c != null));
			if (this.hand.Count != 5 || this.hand.Contains(null)) throw new ArgumentException("Invalid hand.");
			this.isBlue = isBlue;
			this.hand.ForEach(c => c.isBlue = isBlue);
		}

		public int RemainingCards { get { return hand.Count; } }

		public bool isBlue;
		public List<PlayCard> hand;
	}
}