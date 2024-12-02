class Colors extends Object;

var color White;

var color Black;

var color Red;

var color Blue;

var color Yellow;

var color Orange;

var color Green;

var color Cyan;

var color Magenta;

var color Invisible;

////////////////////////////////////////////////////////////////////////////////

static function color CreateColor(
	byte r,
	byte g,
	byte b,
	byte a
) {
	local color colorReturn;

	colorReturn.R = r;
	colorReturn.G = g;
	colorReturn.B = b;
	colorReturn.A = a;

	return colorReturn;
}

////////////////////////////////////////////////////////////////////////////////

static function color MultiplyColor(
	color colorInput,
	float fMultiplier
) {
	local color colorReturn;

	colorReturn.R = colorInput.R * fMultiplier;
	colorReturn.G = colorInput.G * fMultiplier;
	colorReturn.B = colorInput.B * fMultiplier;
	colorReturn.A = colorInput.A * fMultiplier;

	return colorReturn;
}


////////////////////////////////////////////////////////////////////////////////

static function color ScaleColor(
	color c,
	float fScale,
	float fBrighten,
	optional bool bAffectAlpha
) {
	local color effectColor;

	effectColor.R = GetValidColorComponent((c.R * fScale) + (default.White.R * fBrighten));
	effectColor.G = GetValidColorComponent((c.G * fScale) + (default.White.G * fBrighten));
	effectColor.B = GetValidColorComponent((c.B * fScale) + (default.White.B * fBrighten));

	if (bAffectAlpha == true) {
		effectColor.A = GetValidColorComponent((c.A * fScale) + (default.White.A * fBrighten));
	} else {
		effectColor.A = c.A;
	}

	return effectColor;
}

////////////////////////////////////////////////////////////////////////////////

static function byte GetValidColorComponent(
	int i
) {
	if (i < 0) {
		return 0;
	} else if (i > 255) {
		return 255;
	} else {
		return i;
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
    White=(R=255,G=255,B=255,A=255),
    Black=(R=0,G=0,B=0,A=255),
    Red=(R=0,G=0,B=255,A=255),
    Blue=(R=255,G=0,B=0,A=255),
    Yellow=(R=0,G=255,B=255,A=255),
    Orange=(R=0,G=128,B=255,A=255),
    Green=(R=0,G=255,B=0,A=255),
    Cyan=(R=255,G=255,B=0,A=255),
    Magenta=(R=255,G=0,B=255,A=255),
}
