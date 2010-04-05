namespace TripleTriad.Solver
{
	/// <summary>
	/// <remarks>
	/// (0,0) corresponds to upper left corner
	/// </remarks>
	/// </summary>
	public class PlayField
	{
		public FieldCell[,] cell;
		public Element[,] element;

		public PlayField()
		{
			cell = new FieldCell[3,3];
			for (int x = 0; x < cell.GetLength(0); x++)
				for (int y = 0; y < cell.GetLength(1); y++)
				{
					var c = new FieldCell();
					if (x == 0) c.left = 10;
					if (y == 0) c.up = 10;
					if (x == cell.Length) c.right = 10;
					if (y == cell.Length) c.down = 10;
					cell[x, y] = c;
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