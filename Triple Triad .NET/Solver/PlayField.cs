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

		public void Put(PlayCard card, byte x, byte y)
		{
			cell[x, y].card = card;
			if (x > 0) cell[x - 1, y].right = card.cardInfo.Left;
			if (x < cell.Length) cell[x + 1, y].left = card.cardInfo.Right;
			if (y > 0) cell[x, y - 1].down = card.cardInfo.Up;
			if (y < cell.Length) cell[x, y + 1].up = card.cardInfo.Down;
		}

		private PlayField(PlayField playField)
		{
			cell = (FieldCell[,]) playField.cell.Clone();
		}

		public PlayField Clone()
		{
			return new PlayField(this);
		}
	}
}