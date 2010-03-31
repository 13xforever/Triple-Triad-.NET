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
		}

		public State Clone()
		{
			return new State(field, modifiers, blueHand, redHand, bluesTurn);
		}

		private PlayField field;
		private PlayHand blueHand;
		private PlayHand redHand;
		private bool bluesTurn;
		public RuleModifier modifiers;
	}
}