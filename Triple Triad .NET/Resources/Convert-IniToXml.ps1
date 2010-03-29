cd "D:\Documents\Visual Studio 2010\Projects\Triple Triad .NET\Triple Triad .NET\Resources"
$ini = Get-Content Cards.ini
$xml = New-Object xml
$root = $xml.CreateElement("cards")
[Void]$xml.AppendChild($root)

$elements = @('None', 'Fire', 'Ice', 'Thunder', 'Water', 'Wind', 'Earth', 'Poison', 'Holy')

for ($i=0; $i -lt 110; $i++)
{
	$cardName = $ini[$i*7 + 0]
	if (-not $cardName.StartsWith("[")) {throw}
	$cardName = $cardName.Substring(1, $cardName.Length - 2)
	
	$leftParam = $ini[$i*7 + 1]
	if (-not $leftParam.StartsWith("Left=")) {throw}
	$leftParam = $leftParam[$leftParam.Length-1]
	
	$upParam = $ini[$i*7 + 2]
	if (-not $upParam.StartsWith("Up=")) {throw}
	$upParam = $upParam[$upParam.Length-1]
	
	$rightParam = $ini[$i*7 + 3]
	if (-not $rightParam.StartsWith("Right=")) {throw}
	$rightParam = $rightParam[$rightParam.Length-1]
	
	$downParam = $ini[$i*7 + 4]
	if (-not $downParam.StartsWith("Down=")) {throw}
	$downParam = $downParam[$downParam.Length-1]
	
	$elementParam = $ini[$i*7 + 5]
	if (-not $elementParam.StartsWith("Element=")) {throw}
	$elementParam = $elementParam[$elementParam.Length-1]
	$elementParam = $elements[([int]::Parse($elementParam))]
	
	
	$node = $xml.CreateElement("card")
	$node.SetAttribute("id",      $i)
	$node.SetAttribute("name",    $cardName)
	$node.SetAttribute("left",    $leftParam)
	$node.SetAttribute("up",      $upParam)
	$node.SetAttribute("right",   $rightParam)
	$node.SetAttribute("down",    $downParam)
	$node.SetAttribute("element", $elementParam)
	$root.AppendChild($node)
}

$xml.Save("D:\Documents\Visual Studio 2010\Projects\Triple Triad .NET\Triple Triad .NET\Resources\Cards.xml")