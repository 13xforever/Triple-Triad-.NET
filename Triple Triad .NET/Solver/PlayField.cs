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

/*
		public IFieldCell this[byte x, byte y]
		{
			get { return cell[x, y]; }
		}
*/

		public PlayField()
		{
			cell = new FieldCell[length, length];
			for (int x = 0; x < length; x++)
				for (int y = 0; y < length; y++)
				{
					var c = new FieldCell();
					if (x == 0) c.left = 10;
					if (y == 0) c.up = 10;
					if (x == length) c.right = 10;
					if (y == length) c.down = 10;
					cell[x, y] = c;
				}
		}

		public void Put(PlayCard card, byte x, byte y)
		{
			cell[x, y].card = card;
			if (x > 0) cell[x - 1, y].right = card.cardInfo.Left;
			if (x < maxCoord) cell[x + 1, y].left = card.cardInfo.Right;
			if (y > 0) cell[x, y - 1].down = card.cardInfo.Up;
			if (y < maxCoord) cell[x, y + 1].up = card.cardInfo.Down;
		}

		public const int length = 3;
		public const int maxCoord = length - 1;

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