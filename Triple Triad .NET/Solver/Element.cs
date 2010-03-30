using System;

namespace TripleTriad.Solver
{
	[Flags]
	public enum RuleModifier
	{
		Same,
		Plus,
		Combo,
		SameWall,
		Elemental
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