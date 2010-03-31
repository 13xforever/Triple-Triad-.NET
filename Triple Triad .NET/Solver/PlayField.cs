namespace TripleTriad.Solver
{
	public class PlayField
	{
		public FieldCell[,] cell;
		public Element[,] element;

		public PlayField()
		{
			cell = new FieldCell[3,3];
			for (int i = 0; i < cell.GetLength(0); i++)
				for (int j = 0; j < cell.GetLength(1); j++)
				{
					var c = new FieldCell();
					if (i == 0) c.left = 10;
					if (j == 0) c.up = 10;
					if (i == cell.Length) c.right = 10;
					if (j == cell.Length) c.down = 10;
					cell[i, j] = c;
				}
		}

		private PlayField(PlayField playField)
		{
			element = playField.element;
			cell = (FieldCell[,]) playField.cell.Clone();
		}

		public PlayField Clone()
		{
			return new PlayField(this);
		}
	}
}