package utils;

class Score
{
	public var donutHits:Int = 0;
	public var xpDonutHits:Int = 0;
	public var reachedInsane:Int = 0; // Int because it's easy and im dumb

	public function new() {}

	public function calculateScore(timeSurvived:Float, donutHits:Int, isInsane:Int, xpDonutHits:Int)
	{
		// +10 points for close calls, -15 points for donut hits/lost lives
		// there are no close calls lololol, couldnt implement them, too stupid
		return ((((Std.int(timeSurvived) * 10) + 10 * Std.int(timeSurvived / 60)) + 15 * xpDonutHits) + 25 * isInsane) - 15 * donutHits;
	}
}
