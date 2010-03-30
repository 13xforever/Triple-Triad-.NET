using System;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using System.Xml;

namespace TripleTriad.Solver
{
	public class CardInfo
	{
		private static readonly Dictionary<string, CardInfo> cardPool;
		private byte down;
		private Element element;
		private byte id;
		private byte left;
		private string name;
		private byte right;
		private byte up;

		static CardInfo()
		{
			cardPool = new Dictionary<string, CardInfo>(StringComparer.InvariantCultureIgnoreCase);
			var currentAssembly = Assembly.GetExecutingAssembly();
			var resourceName = currentAssembly.GetManifestResourceNames().Single(s => s.EndsWith("cards.xml", StringComparison.InvariantCultureIgnoreCase));
			var xml = new XmlDocument();
			xml.Load(currentAssembly.GetManifestResourceStream(resourceName));
			foreach (XmlElement card in xml.DocumentElement.ChildNodes)
			{
				var c = new CardInfo(card.GetAttribute("id"),
				                     card.GetAttribute("name"),
				                     card.GetAttribute("left"),
				                     card.GetAttribute("up"),
				                     card.GetAttribute("right"),
				                     card.GetAttribute("down"),
				                     card.GetAttribute("element"));
				cardPool.Add(c.name, c);
			}
		}

		private CardInfo(string id, string name, string left, string up, string right, string down, string element)
		{
			byte.TryParse(id, out this.id);
			this.name = name;
			byte.TryParse(left, out this.left);
			byte.TryParse(up, out this.up);
			byte.TryParse(right, out this.right);
			byte.TryParse(down, out this.down);
			Element.TryParse(element, out this.element);
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
		public static Dictionary<string, CardInfo> CardPool { get { return cardPool; } }

		public static CardInfo CreateCard(byte id, string name, byte left, byte up, byte right, byte down, Element element)
		{
			return Intern(new CardInfo(id, name, left, up, right, down, element));
		}

		public static CardInfo Intern(CardInfo cardInfo)
		{
			if (cardInfo == null) throw new ArgumentNullException("cardInfo");
			if (cardPool.ContainsKey(cardInfo.name)) return cardPool[cardInfo.name];
			cardPool[cardInfo.name] = cardInfo;
			return cardInfo;
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
			return other.name == name;
		}

		public override int GetHashCode()
		{
			return id.GetHashCode();
		}

		public override string ToString()
		{
			return name;
		}
	}
}