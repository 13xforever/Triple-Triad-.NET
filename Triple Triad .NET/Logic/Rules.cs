using System;
using System.Buffers;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TripleTriad.Utils;

namespace TripleTriad.Logic
{
	public class Rules
	{
		private readonly bool elemental;
		private readonly bool plus;
		private readonly bool same;
		private readonly bool sameWall;
		private readonly bool combo;

		public Rules(bool elemental = false, bool plus = false, bool same = false, bool sameWall = false)
		{
			if (sameWall && !same)
				throw new ArgumentException("Same Wall rule was enabled, but not the Same rule");

			this.elemental = elemental;
			this.plus = plus;
			this.same = same;
			this.sameWall = sameWall;
			combo = plus || same || sameWall;
		}

		public (Card card, byte position, Stats stats) FindBestMove(State state, Color startHand)
		{
			var hand = startHand == Color.Blue ? state.BlueHand : state.PinkHand;
			var cardsToPlay = hand.OrderBy(c => c.Value.Id).Distinct().ToArray();
			var states = new (PlayCard c, Task t, byte i, Stats s)[cardsToPlay.Length];
			for (byte i = 0; i < states.Length; i++)
			{
				var x = i;
				states[x].c = cardsToPlay[x];
				states[x].t = Task.Run(() =>
				{
					var bestResult = new Stats
					{
						Defeats = int.MaxValue,
						Draws = int.MaxValue,
						Wins = 0,
					};
					var latestResult = new Stats();
					byte bestIdx = 0;
					for (byte idx = 0; idx < 9; idx++)
					{
						if (state.Field[idx].Card != null)
							continue;

						SearchInDepth(state, states[x].c, idx, ref latestResult);
						if (bestResult.Defeats > latestResult.Defeats
							|| bestResult.Defeats == latestResult.Defeats && bestResult.Draws > latestResult.Draws)
						{
							bestResult = latestResult;
							bestIdx = idx;
						}
					}
					states[x].s = bestResult;
					states[x].i = bestIdx;
				});
				states[x].t.GetAwaiter().GetResult();
			}
			foreach (var (_, t, _,  _) in states)
				t.ConfigureAwait(false).GetAwaiter().GetResult();
			var bestMove = states.OrderBy(s => s.s.Defeats).ThenBy(s => s.s.Draws).First();
			return (bestMove.c.Value, bestMove.i, bestMove.s);
		}

		private void SearchInDepth(State state, PlayCard card, byte idx, ref Stats stats)
		{
			var newState = new State();
			if (card.Color == Color.Blue)
			{
				newState.BlueHand = state.BlueHand;
				newState.PinkHand = state.PinkHand.Exclude(card); // todo: stackalloc
			}
			else
			{
				newState.BlueHand = state.BlueHand.Exclude(card);
				newState.PinkHand = state.PinkHand;
			}
			var newField = ArrayPool<Cell>.Shared.Rent(9);
			newState.Field = newField;
			Array.Copy(state.Field, newField, 9);
			newField[idx] = state.Field[idx].With(card);
			Play(newField, idx);
			if (newState.IsFinished)
			{
				byte pinkCount = 0;
				for (var i = 0; i < 9; i++)
				{
					var cell = newState.Field[i];
					if (cell.Card?.Color == Color.Pink)
						pinkCount++;
					if (newState.PinkHand.Length == 1)
						pinkCount++;
					if (pinkCount > 5)
						stats.Wins++;
					else if (pinkCount == 5)
						stats.Draws++;
					else
						stats.Defeats++;
				}
			}
			else
			{
				var oppositeHand = card.Color == Color.Blue ? newState.PinkHand : newState.BlueHand;
				foreach (var pc in oppositeHand)
					for (byte nIdx = 0; nIdx < 9; nIdx++)
						if (newField[nIdx].Card == null)
							SearchInDepth(newState, pc, nIdx, ref stats);
			}
			ArrayPool<Cell>.Shared.Return(newField);
		}

		public State Play(State state, PlayCard card, byte idx)
		{
			var newState = new State
			{
				Field = new Cell[9],
				BlueHand = state.BlueHand,
				PinkHand = state.PinkHand,
			};
			Array.Copy(state.Field, newState.Field, 9);
			newState.Field[idx] = state.Field[idx].With(card);
			if (card.Color == Color.Pink)
				newState.PinkHand = state.PinkHand.Exclude(card);
			else
				newState.BlueHand = state.BlueHand.Exclude(card);
			Play(newState.Field, idx);
			return newState;
		}

		private void Play(Cell[] field, byte idx)
		{
			/*
			 * 0 1 2
			 * 3 4 5
			 * 6 7 8
			 */
			byte opponentAdjacentCardCount = 0;
			byte totalAdjacentCardCount = 0;
			var oppositeColor = (Color)((byte)field[idx].Card.Color ^ 1);

			void oppositeCheck(PlayCard c)
			{
				totalAdjacentCardCount++;
				if (c.Color == oppositeColor)
					opponentAdjacentCardCount++;
			}
			switch (idx)
			{
				case 0:
				{
					if (field[1].Card is PlayCard c1) oppositeCheck(c1);
					if (field[3].Card is PlayCard c3) oppositeCheck(c3);
					break;
				}
				case 1:
				{
					if (field[0].Card is PlayCard c0) oppositeCheck(c0);
					if (field[2].Card is PlayCard c2) oppositeCheck(c2);
					if (field[4].Card is PlayCard c4) oppositeCheck(c4);
					break;
				}
				case 2:
				{
					if (field[1].Card is PlayCard c1) oppositeCheck(c1);
					if (field[5].Card is PlayCard c5) oppositeCheck(c5);
					break;
				}
				case 3:
				{
					if (field[0].Card is PlayCard c0) oppositeCheck(c0);
					if (field[4].Card is PlayCard c4) oppositeCheck(c4);
					if (field[6].Card is PlayCard c6) oppositeCheck(c6);
					break;
				}
				case 4:
				{
					if (field[1].Card is PlayCard c1) oppositeCheck(c1);
					if (field[3].Card is PlayCard c3) oppositeCheck(c3);
					if (field[5].Card is PlayCard c5) oppositeCheck(c5);
					if (field[7].Card is PlayCard c7) oppositeCheck(c7);
					break;
				}
				case 5:
				{
					if (field[2].Card is PlayCard c2) oppositeCheck(c2);
					if (field[4].Card is PlayCard c4) oppositeCheck(c4);
					if (field[5].Card is PlayCard c8) oppositeCheck(c8);
					break;
				}
				case 6:
				{
					if (field[3].Card is PlayCard c3) oppositeCheck(c3);
					if (field[7].Card is PlayCard c7) oppositeCheck(c7);
					break;
				}
				case 7:
				{
					if (field[4].Card is PlayCard c4) oppositeCheck(c4);
					if (field[6].Card is PlayCard c6) oppositeCheck(c6);
					if (field[8].Card is PlayCard c8) oppositeCheck(c8);
					break;
				}
				case 8:
				{
					if (field[5].Card is PlayCard c5) oppositeCheck(c5);
					if (field[7].Card is PlayCard c7) oppositeCheck(c7);
					break;
				}

			}
			if (opponentAdjacentCardCount == 0)
				return;

			bool sameCmp(byte pinkA, byte blueA, byte pinkB, byte blueB) => pinkA == blueA && pinkB == blueB;
			bool plusCmp(byte pinkA, byte blueA, byte pinkB, byte blueB) => pinkA + blueA == pinkB + blueB;
			bool sameOrPlusCmp(byte pinkA, byte blueA, byte pinkB, byte blueB)
				=> same && sameCmp(pinkA, blueA, pinkB, blueB)
					|| plus && plusCmp(pinkA, blueA, pinkB, blueB);

			void adjustValue(Cell cell, ref byte value)
			{
				if (cell.Element == Element.None || cell.Card.Value.Element == Element.None)
					return;

				if (cell.Element == cell.Card.Value.Element)
					value++;
				else
					value--;
			}
			void simpleDownCmp(Cell center, Cell down)
			{
				if (down.Card is PlayCard d && center.Card.Color != d.Color)
				{
					var centerValue = center.Card.Value.Down;
					var downValue = d.Value.Up;
					if (elemental)
					{
						adjustValue(center, ref centerValue);
						adjustValue(down, ref downValue);
					}
					if (downValue < centerValue)
						d.Color = center.Card.Color;
				}
			}
			void simpleUpCmp(Cell center, Cell up)
			{
				if (up.Card is PlayCard u && center.Card.Color != u.Color)
				{
					var centerValue = center.Card.Value.Up;
					var upValue = u.Value.Down;
					if (elemental)
					{
						adjustValue(center, ref centerValue);
						adjustValue(up, ref upValue);
					}
					if (upValue < centerValue)
						u.Color = center.Card.Color;
				}
			}
			void simpleRightCmp(Cell center, Cell right)
			{
				if (right.Card is PlayCard l && center.Card.Color != l.Color)
				{
					var centerValue = center.Card.Value.Right;
					var rightValue = l.Value.Left;
					if (elemental)
					{
						adjustValue(center, ref centerValue);
						adjustValue(right, ref rightValue);
					}
					if (rightValue < centerValue)
						l.Color = center.Card.Color;
				}
			}
			void simpleLeftCmp(Cell center, Cell left)
			{
				if (left.Card is PlayCard l && center.Card.Color != l.Color)
				{
					var centerValue = center.Card.Value.Left;
					var leftValue = l.Value.Right;
					if (elemental)
					{
						adjustValue(center, ref centerValue);
						adjustValue(left, ref leftValue);
					}
					if (leftValue < centerValue)
						l.Color = center.Card.Color;
				}
			}

			void comboLeftDownCmp(PlayCard center, Cell left, Cell down, HashSet<byte> comboCards)
			{
				if (left.Card is PlayCard l
					&& down.Card is PlayCard d
					&& (l.Color != center.Color || d.Color != center.Color))
				{
					if (sameOrPlusCmp(center.Value.Left, l.Value.Right, center.Value.Down, d.Value.Up))
					{
						if (l.Color != center.Color)
							comboCards.Add(left.Id);
						if (d.Color != center.Color)
							comboCards.Add(down.Id);
					}
				}
			}
			void comboLeftRightCmp(PlayCard center, Cell left, Cell right, HashSet<byte> comboCards)
			{
				if (left.Card is PlayCard l
					&& right.Card is PlayCard r
					&& (l.Color != center.Color || r.Color != center.Color))
				{
					if (sameOrPlusCmp(center.Value.Left, l.Value.Right, center.Value.Right, r.Value.Left))
					{
						if (l.Color != center.Color)
							comboCards.Add(left.Id);
						if (r.Color != center.Color)
							comboCards.Add(right.Id);
					}
				}
			}
			void comboLeftUpCmp(PlayCard center, Cell left, Cell up, HashSet<byte> comboCards)
			{
				if (left.Card is PlayCard l
					&& up.Card is PlayCard u
					&& (l.Color != center.Color || u.Color != center.Color))
				{
					if (sameOrPlusCmp(center.Value.Left, l.Value.Right, center.Value.Up, u.Value.Down))
					{
						if (l.Color != center.Color)
							comboCards.Add(left.Id);
						if (u.Color != center.Color)
							comboCards.Add(up.Id);
					}
				}
			}
			void comboDownRightCmp(PlayCard center, Cell down, Cell right, HashSet<byte> comboCards)
			{
				if (down.Card is PlayCard d
					&& right.Card is PlayCard r
					&& (d.Color != center.Color || r.Color != center.Color))
				{
					if (sameOrPlusCmp(center.Value.Down, d.Value.Up, center.Value.Right, r.Value.Left))
					{
						if (d.Color != center.Color)
							comboCards.Add(down.Id);
						if (r.Color != center.Color)
							comboCards.Add(right.Id);
					}
				}
			}
			void comboDownUpCmp(PlayCard center, Cell down, Cell up, HashSet<byte> comboCards)
			{
				if (down.Card is PlayCard d
					&& up.Card is PlayCard u
					&& (d.Color != center.Color || u.Color != center.Color))
				{
					if (sameOrPlusCmp(center.Value.Down, d.Value.Up, center.Value.Up, u.Value.Down))
					{
						if (d.Color != center.Color)
							comboCards.Add(down.Id);
						if (u.Color != center.Color)
							comboCards.Add(up.Id);
					}
				}
			}
			void comboRightUpCmp(PlayCard center, Cell right, Cell up, HashSet<byte> comboCards)
			{
				if (right.Card is PlayCard r
					&& up.Card is PlayCard u
					&& (r.Color != center.Color || u.Color != center.Color))
				{
					if (sameOrPlusCmp(center.Value.Right, r.Value.Left, center.Value.Up, u.Value.Down))
					{
						if (r.Color != center.Color)
							comboCards.Add(right.Id);
						if (u.Color != center.Color)
							comboCards.Add(up.Id);
					}
				}
			}

			void doSimpleFlips(byte startIdx)
			{
				var c = field[startIdx];
				/*
				 * 0 1 2
				 * 3 4 5
				 * 6 7 8
				 */
				switch (startIdx)
				{
					case 0:
					{
						simpleRightCmp(c, field[1]);
						simpleDownCmp(c, field[3]);
						break;
					}
					case 1:
					{
						simpleLeftCmp(c, field[0]);
						simpleDownCmp(c, field[4]);
						simpleRightCmp(c, field[2]);
						break;
					}
					case 2:
					{
						simpleLeftCmp(c, field[1]);
						simpleDownCmp(c, field[5]);
						break;
					}
					case 3:
					{
						simpleUpCmp(c, field[0]);
						simpleRightCmp(c, field[4]);
						simpleDownCmp(c, field[6]);
						break;
					}
					case 4:
					{
						simpleUpCmp(c, field[1]);
						simpleLeftCmp(c, field[3]);
						simpleRightCmp(c, field[5]);
						simpleDownCmp(c, field[7]);
						break;
					}
					case 5:
					{
						simpleUpCmp(c, field[2]);
						simpleLeftCmp(c, field[4]);
						simpleDownCmp(c, field[8]);
						break;
					}
					case 6:
					{
						simpleUpCmp(c, field[3]);
						simpleRightCmp(c, field[7]);
						break;
					}
					case 7:
					{
						simpleUpCmp(c, field[4]);
						simpleLeftCmp(c, field[6]);
						simpleRightCmp(c, field[8]);
						break;
					}
					case 8:
					{
						simpleUpCmp(c, field[5]);
						simpleLeftCmp(c, field[7]);
						break;
					}
				}
			}
			void doComboFlips(byte startIdx, HashSet<byte> comboCards)
			{
				var center = field[startIdx].Card;
				var c = center.Value;
				switch (startIdx)
				{
					// corners
					/*
					 * 0 1 2
					 * 3 4 5
					 * 6 7 8
					 */
					case 0:
					{
						if (field[1].Card is PlayCard right && right.Color == oppositeColor)
						{
							if (field[3].Card is PlayCard down)
							{
								if (sameOrPlusCmp(c.Right, right.Value.Left, c.Down, down.Value.Up))
								{
									comboCards.Add(1);
									comboCards.Add(3);
								}
								else if (sameWall && (c.Up == 10 || c.Left == 10))
								{
									if (c.Right == right.Value.Left)
										comboCards.Add(1);
									if (down.Color == oppositeColor && c.Down == down.Value.Up)
										comboCards.Add(3);
								}
							}
							else if (sameWall && (c.Up == 10 || c.Left == 10) && c.Right == right.Value.Left)
								comboCards.Add(1);
						}
						else if (field[3].Card is PlayCard down && down.Color == oppositeColor)
						{
							if (sameWall && c.Down == down.Value.Up && (c.Up == 10 || c.Left == 10))
								comboCards.Add(3);
						}
						break;
					}
					case 2:
					{
						if (field[1].Card is PlayCard left && left.Color == oppositeColor)
						{
							if (field[5].Card is PlayCard down)
							{
								if (sameOrPlusCmp(c.Left, left.Value.Right, c.Down, down.Value.Up))
								{
									comboCards.Add(1);
									comboCards.Add(5);
								}
								else if (sameWall && (c.Up == 10 || c.Right == 10))
								{
									if (c.Left == left.Value.Right)
										comboCards.Add(1);
									if (down.Color == oppositeColor && c.Down == down.Value.Up)
										comboCards.Add(5);
								}
							}
							else if (sameWall && (c.Up == 10 || c.Right == 10) && c.Left == left.Value.Right)
								comboCards.Add(1);
						}
						else if (field[5].Card is PlayCard down && down.Color == oppositeColor)
						{
							if (sameWall && c.Down == down.Value.Up && (c.Up == 10 || c.Right == 10))
								comboCards.Add(5);
						}
						break;
					}
					case 8:
					{
						if (field[7].Card is PlayCard left && left.Color == oppositeColor)
						{
							if (field[5].Card is PlayCard up)
							{
								if (sameOrPlusCmp(c.Left, left.Value.Right, c.Up, up.Value.Down))
								{
									comboCards.Add(7);
									comboCards.Add(5);
								}
								else if (sameWall && (c.Down == 10 || c.Right == 10))
								{
									if (c.Left == left.Value.Right)
										comboCards.Add(7);
									if (up.Color == oppositeColor && c.Up == up.Value.Down)
										comboCards.Add(5);
								}
							}
							else if (sameWall && (c.Down == 10 || c.Right == 10) && c.Left == left.Value.Right)
								comboCards.Add(7);
						}
						else if (field[5].Card is PlayCard up && up.Color == oppositeColor)
						{
							if (sameWall && c.Up == up.Value.Down && (c.Down == 10 || c.Right == 10))
								comboCards.Add(5);
						}
						break;
					}
					case 6:
					{
						if (field[7].Card is PlayCard right && right.Color == oppositeColor)
						{
							if (field[3].Card is PlayCard up)
							{
								if (sameOrPlusCmp(c.Right, right.Value.Left, c.Up, up.Value.Down))
								{
									comboCards.Add(7);
									comboCards.Add(3);
								}
								else if (sameWall && (c.Down == 10 || c.Left == 10))
								{
									if (c.Right == right.Value.Left)
										comboCards.Add(7);
									if (up.Color == oppositeColor && c.Up == up.Value.Down)
										comboCards.Add(3);
								}
							}
							else if (sameWall && (c.Down == 10 || c.Left == 10) && c.Right == right.Value.Left)
								comboCards.Add(7);
						}
						else if (field[3].Card is PlayCard up && up.Color == oppositeColor)
						{
							if (sameWall && c.Up == up.Value.Down && (c.Down == 10 || c.Left == 10))
								comboCards.Add(3);
						}
						break;
					}
					// middle of the edges
					/*
					 * 0 1 2
					 * 3 4 5
					 * 6 7 8
					 */
					case 1:
					{
						var left = field[0];
						var down = field[4];
						var right = field[2];
						comboLeftDownCmp(center, left, down, comboCards);
						comboLeftRightCmp(center, left, right, comboCards);
						comboDownRightCmp(center, down, right, comboCards);
						if (sameWall && c.Up == 10)
						{
							if (c.Left == left.Card?.Value.Right)
								comboCards.Add(0);
							if (c.Down == down.Card?.Value.Up)
								comboCards.Add(4);
							if (c.Right == right.Card?.Value.Left)
								comboCards.Add(2);
						}
						break;
					}
					case 3:
					{
						var down = field[6];
						var right = field[4];
						var up = field[0];
						comboDownRightCmp(center, down, right, comboCards);
						comboDownUpCmp(center, down, up, comboCards);
						comboRightUpCmp(center, right, up, comboCards);
						if (sameWall && c.Left == 10)
						{
							if (c.Down == down.Card?.Value.Up)
								comboCards.Add(6);
							if (c.Right == right.Card?.Value.Left)
								comboCards.Add(4);
							if (c.Up == up.Card?.Value.Down)
								comboCards.Add(0);
						}
						break;
					}
					case 5:
					{
						var left = field[4];
						var down = field[8];
						var up = field[2];
						comboLeftDownCmp(center, left, down, comboCards);
						comboLeftUpCmp(center, left, up, comboCards);
						comboDownUpCmp(center, left, down, comboCards);
						if (sameWall && c.Right == 10)
						{
							if (c.Left == left.Card?.Value.Right)
								comboCards.Add(4);
							if (c.Down == down.Card?.Value.Up)
								comboCards.Add(8);
							if (c.Up == up.Card?.Value.Down)
								comboCards.Add(2);
						}
						break;
					}
					case 7:
					{
						var left = field[6];
						var right = field[8];
						var up = field[4];
						comboLeftRightCmp(center, left, right, comboCards);
						comboLeftUpCmp(center, left, up, comboCards);
						comboRightUpCmp(center, right, up, comboCards);
						if (sameWall && c.Down == 10)
						{
							if (c.Left == left.Card?.Value.Right)
								comboCards.Add(6);
							if (c.Right == right.Card?.Value.Left)
								comboCards.Add(8);
							if (c.Up == up.Card?.Value.Down)
								comboCards.Add(4);
						}
						break;
					}
					// dead center
					/*
					* 0 1 2
					* 3 4 5
					* 6 7 8
					*/
					case 4:
					{
						var left = field[3];
						var down = field[7];
						var right = field[5];
						var up = field[1];
						comboLeftDownCmp(center, left, down, comboCards);
						comboLeftRightCmp(center, left, right, comboCards);
						comboLeftUpCmp(center, left, up, comboCards);
						comboDownRightCmp(center, down, right, comboCards);
						comboDownUpCmp(center, down, up, comboCards);
						comboRightUpCmp(center, right, up, comboCards);
						break;
					}
				}
			}

			if (combo)
			{
				var comboFlips = new HashSet<byte>(4);
				doComboFlips(idx, comboFlips);
				foreach (var comboIdx in comboFlips)
					doSimpleFlips(comboIdx);
			}
			doSimpleFlips(idx);
		}
	}
}