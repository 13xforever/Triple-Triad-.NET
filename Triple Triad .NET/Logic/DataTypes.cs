using System;
using System.Buffers;
using System.Globalization;
using System.Linq;

namespace TripleTriad.Logic
{
	public enum Element: byte
	{
		None,
		Fire,
		Ice,
		Thunder,
		Water,
		Wind,
		Earth,
		Poison,
		Holy,
	}

	public class Card
	{
		private Card(byte id, byte up, byte right, byte down, byte left, Element element, string name)
		{
			Id = id;
			Up = up;
			Right = right;
			Down = down;
			Left = left;
			Element = element;
			Name = name;
		}

		public readonly byte Id;
		public readonly byte Up;
		public readonly byte Right;
		public readonly byte Down;
		public readonly byte Left;
		public readonly Element Element;
		public readonly string Name;

		public static Card Parse(byte id, string description)
		{
			var parts = description.Split(splitter, 2);
			var up = byte.Parse(parts[0].Substring(0, 1), NumberStyles.HexNumber);
			var right = byte.Parse(parts[0].Substring(1, 1), NumberStyles.HexNumber);
			var down = byte.Parse(parts[0].Substring(2, 1), NumberStyles.HexNumber);
			var left = byte.Parse(parts[0].Substring(3, 1), NumberStyles.HexNumber);
			Element e;
			switch (parts[0].Substring(4))
			{
				case "🔥":
					e = Element.Fire;
					break;
				case "❄":
					e = Element.Ice;
					break;
				case "⚡":
					e = Element.Thunder;
					break;
				case "💧":
					e = Element.Water;
					break;
				case "🌪":
					e = Element.Wind;
					break;
				case "⛰":
					e = Element.Earth;
					break;
				case "🟣":
					e = Element.Poison;
					break;
				case "✨":
					e = Element.Holy;
					break;
				default:
					e = Element.None;
					break;
			}
			return new Card(id, up, right, down, left, e, parts[1]);
		}

		private static readonly char[] splitter = { '\t' };
	}

	public enum Color : byte
	{
		Pink,
		Blue,
	}

	public class PlayCard
	{
		public PlayCard(Card card, Color color)
		{
			Value = card;
			Color = color;
		}

		public readonly Card Value;
		public Color Color;

		public PlayCard Duplicate() => new PlayCard(Value, Color);

		public override bool Equals(object obj) {
			if (ReferenceEquals(null, obj)) return false;
			if (ReferenceEquals(this, obj)) return true;
			if (obj.GetType() != this.GetType()) return false;
			return Equals((PlayCard) obj);
		}

		public bool Equals(PlayCard other) => Value.Id == other.Value.Id && Color == other.Color;

		public override int GetHashCode()
		{
			unchecked
			{
				return (Value.Id.GetHashCode() * 397) ^ (int) Color;
			}
		}
	}

	public class Cell
	{
		public Cell(byte id, Element element, PlayCard playCard)
		{
			Id = id;
			Element = element;
			Card = playCard;
		}

		public readonly byte Id;
		public readonly Element Element;
		public readonly PlayCard Card;

		public Cell With(PlayCard newCard) => new Cell(Id, Element, newCard);
		public Cell With(Element newElement) => new Cell(Id, newElement, Card);
	}

	public static class Field
	{
		static Field()
		{
			Default = new Cell[9];
			for (byte i = 0; i < 9; i++)
				Default[i] = new Cell(i, Element.None, null);
		}

		public static readonly Cell[] Default;
	}

	public struct State
	{
		public PlayCard[] BlueHand;
		public PlayCard[] PinkHand;
		public Cell[] Field;

		public bool IsFinished => BlueHand.Length + PinkHand.Length == 1;
		public int PinkScore => Field.Count(c => c.Card?.Color == Color.Pink) + PinkHand.Length;
		public void SetElement(byte idx, Element e) => Field[idx] = Field[idx].With(e);
	}

	public struct Stats
	{
		public int Wins;
		public int Draws;
		public int Defeats;
	}
}
