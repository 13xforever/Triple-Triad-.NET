namespace TripleTriad.Solver
{
	public struct FieldCell
	{
		public byte left;
		public byte up;
		public byte right;
		public byte down;
		public PlayCard card;
		public Element element;

		public bool Occupied { get { return card.cardInfo != null; } }
	}
}