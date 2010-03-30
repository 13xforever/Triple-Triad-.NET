using System;

namespace TripleTriad.Solver
{
	[Flags]
	public enum RuleModifier
	{
		None	 = 0x00,
		Same	 = 0x01,
		Plus	 = 0x02,
		Combo	 = 0x04,
		SameWall = 0x08,
		Elemental= 0x10
	}

	public enum Element
	{
		None,
		Fire,
		Ice,
		Thunder,
		Water,
		Wind,
		Earth,
		Poison,
		Holy
	}
}