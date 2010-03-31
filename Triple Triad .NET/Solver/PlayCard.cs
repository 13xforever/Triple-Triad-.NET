namespace TripleTriad.Solver
{
	public struct PlayCard
	{
		public PlayCard(CardInfo cardInfo)
		{
			this.cardInfo = cardInfo;
			inUse = false;
			isBlue = false;
		}
		public PlayCard(CardInfo cardInfo, bool isBlue): this(cardInfo)
		{
			this.isBlue = isBlue;
		}

		public void Flip()
		{
			isBlue = !isBlue;
		}

		public CardInfo cardInfo;
		public bool isBlue;
		public bool inUse;
	}
}