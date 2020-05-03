$ini = Get-Content Cards.ini
$txt = ''
$elements = @('', '🔥', '❄', '⚡', '💧', '🌪', '⛰', '☣', '✨')

for ($i = 0; $i -lt 110; $i++)
{
	$cardName = $ini[$i * 7 + 0]
	if (-not $cardName.StartsWith("[")) { throw }
	$cardName = $cardName.Substring(1, $cardName.Length - 2)
	
	$leftParam = $ini[$i * 7 + 1]
	if (-not $leftParam.StartsWith("Left=")) { throw }
	$leftParam = $leftParam[$leftParam.Length - 1]
	
	$upParam = $ini[$i * 7 + 2]
	if (-not $upParam.StartsWith("Up=")) { throw }
	$upParam = $upParam[$upParam.Length - 1]
	
	$rightParam = $ini[$i * 7 + 3]
	if (-not $rightParam.StartsWith("Right=")) { throw }
	$rightParam = $rightParam[$rightParam.Length - 1]
	
	$downParam = $ini[$i * 7 + 4]
	if (-not $downParam.StartsWith("Down=")) { throw }
	$downParam = $downParam[$downParam.Length - 1]
	
	$elementParam = $ini[$i * 7 + 5]
	if (-not $elementParam.StartsWith("Element=")) { throw }
	$elementParam = $elementParam[$elementParam.Length - 1]
	$elementParam = $elements[([int]::Parse($elementParam))]
	
	$txt += "$upParam$rightParam$downParam$leftParam$elementParam	$cardName" + [Environment]::NewLine
}

$txt.TrimEnd() | Set-Content Cards.txt -Encoding utf8BOM