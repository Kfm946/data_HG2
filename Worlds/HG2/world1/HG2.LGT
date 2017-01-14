
Light("Light 1", 1314289596)
{
	Rotation(-0.066703, 0.009887, -0.918703, 0.389150);
	Position(134.026138, 7.339914, -106.739296);
	Type(3);
	Color(0.901961, 0.901961, 0.823529);
	CastShadow();
	Static();
	CastSpecular(1);
	Range(20.000000);
	Cone(0.785398, 1.570796);
	PS2BlendMode(0);
	Bidirectional(0);
}

Light("Sunlight", 3564864649)
{
	Rotation(0.831554, 0.265854, -0.464504, 0.148724);
	Position(512.014160, -0.000002, -511.994110);
	Type(1);
	Color(0.666667, 0.721569, 0.729412);
	CastShadow();
	Static();
	CastSpecular(1);
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
