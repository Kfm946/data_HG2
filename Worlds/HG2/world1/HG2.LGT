
Light("lobby_light3", 1036950231)
{
	Rotation(0.707751, 0.706462, 0.000000, 0.000000);
	Position(472.112885, -15.510282, -44.997650);
	Type(2);
	Color(1.000000, 1.000000, 0.909804);
	Static();
	CastSpecular(1);
	Range(25.000000);
}

Light("lobby_light4", 1188278493)
{
	Rotation(0.703857, 0.710341, 0.000000, 0.000000);
	Position(482.126190, -15.514779, -49.921085);
	Type(2);
	Color(1.000000, 1.000000, 0.909804);
	Static();
	CastSpecular(1);
	Range(25.000000);
}

Light("lobby_light1", 2526681748)
{
	Rotation(0.703277, 0.710916, 0.000000, 0.000000);
	Position(472.090393, -15.505561, -52.352093);
	Type(2);
	Color(1.000000, 1.000000, 0.909804);
	Static();
	CastSpecular(1);
	Range(25.000000);
}

Light("lobby_light2", 2966736742)
{
	Rotation(0.703857, 0.710341, 0.000000, 0.000000);
	Position(482.131500, -15.505906, -35.181892);
	Type(2);
	Color(1.000000, 1.000000, 0.909804);
	Static();
	CastSpecular(1);
	Range(30.000000);
}

Light("Sunlight", 3564864649)
{
	Rotation(0.666454, 0.702298, -0.220089, 0.119076);
	Position(512.014160, -0.000002, -511.994110);
	Type(1);
	Color(0.501961, 0.501961, 0.501961);
	CastShadow();
	Static();
	PS2BlendMode(0);
	TileUV(1.000000,1.000000);
	OffsetUV(0.000000,0.000000);
}

GlobalLights()
{
	Light1("Sunlight");
	Light2("");
	Top(128, 128, 128);
	Bottom(128, 128, 128);
}
