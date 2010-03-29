using System;
using System.Collections.Generic;

namespace TripleTriad.Solver
{
	public class CardInfo
	{
		private static readonly Dictionary<byte, CardInfo> cardPool;
		private byte down;
		private Element element;
		private byte id;
		private byte left;
		private string name;
		private byte right;
		private byte up;

		static CardInfo()
		{
			cardPool = new Dictionary<byte, CardInfo>();
		}

		public CardInfo(byte id, string name, byte left, byte up, byte right, byte down, Element element)
		{
			this.id = id;
			this.name = name;
			this.left = left;
			this.up = up;
			this.right = right;
			this.down = down;
			this.element = element;
		}

		public byte Up { get { return up; } }
		public byte Right { get { return right; } }
		public string Name { get { return name; } }
		public byte Left { get { return left; } }
		public Element Element { get { return element; } }
		public byte Down { get { return down; } }

		public static CardInfo CreateCard(byte id, string name, byte left, byte up, byte right, byte down, Element element)
		{
			return Intern(new CardInfo(id, name, left, up, right, down, element));
		}

		public override bool Equals(object obj)
		{
			if (ReferenceEquals(null, obj)) return false;
			if (ReferenceEquals(this, obj)) return true;
			return obj.GetType() == typeof (CardInfo) && Equals((CardInfo) obj);
		}

		public bool Equals(CardInfo other)
		{
			if (ReferenceEquals(null, other)) return false;
			if (ReferenceEquals(this, other)) return true;
			return other.id == id;
		}

		public override int GetHashCode()
		{
			return id.GetHashCode();
		}

		public static CardInfo Intern(CardInfo cardInfo)
		{
			if (cardInfo == null) throw new ArgumentNullException("cardInfo");
			if (cardPool.ContainsKey(cardInfo.id)) return cardPool[cardInfo.id];
			cardPool[cardInfo.id] = cardInfo;
			return cardInfo;
		}
	}
}