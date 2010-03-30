namespace TripleTriad.Solver
{
	public class PlayCard
	{
		public PlayCard(){}
		public PlayCard(CardInfo cardInfo)
		{
			this.cardInfo = cardInfo;
			inUse = false;
		}
		public PlayCard(CardInfo cardInfo, bool isBlue): this(cardInfo)
		{
			this.isBlue = isBlue;
		}

		public CardInfo cardInfo;
		public bool isBlue;
		public bool inUse;
	}
}