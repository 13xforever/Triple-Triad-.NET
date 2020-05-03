using System;
using System.Buffers;

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
		public byte Id;
		public byte Up;
		public byte Right;
		public byte Down;
		public byte Left;
		public Element Element;
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

		public Cell Duplicate(PlayCard newCard) => new Cell(Id, Element, newCard);
	}

	public struct State
	{
		public PlayCard[] BlueHand;
		public PlayCard[] PinkHand;
		public Cell[] Field;

		public bool IsFinished => BlueHand.Length + PinkHand.Length == 1;
	}

	public struct Stats
	{
		public int Wins;
		public int Draws;
		public int Defeats;
	}
}
