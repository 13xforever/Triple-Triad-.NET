using System;
using System.Collections.Generic;
using System.Linq;
using TripleTriad.Util;

namespace TripleTriad.Solver
{
	public class PlayHand
	{
		public PlayHand(IEnumerable<PlayCard> hand, bool isBlue)
		{
			this.hand = hand.ToArray();
			//if (this.hand.Length != 5) throw new ArgumentException("Invalid hand.");
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

		public PlayCard Extract(CardInfo cardInfo)
		{
			byte i = 0;
			while (hand[i].cardInfo != cardInfo) i++;
			return Extract(i);
		}

		public PlayCard Extract(byte positionInHand)
		{
			if (RemainingCards == 0) throw new InvalidOperationException("Hand is empty.");
			if (RemainingCards < positionInHand+1) throw new ArgumentException("Too few cards in hand.", "positionInHand");

			PlayCard result = hand[positionInHand];
			result.inUse = true;
			hand = hand.CopyExceptElementAt(positionInHand);
			return result;
		}
	}
}