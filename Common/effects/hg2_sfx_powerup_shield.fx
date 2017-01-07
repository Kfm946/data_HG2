ParticleEmitter("BigRings")
{
	MaxParticles(5.0000,5.0000);
	StartDelay(0.0000,0.0000);
	BurstDelay(0.0400, 0.0400);
	BurstCount(1.0000,1.0000);
	MaxLodDist(50.0000);
	MinLodDist(10.0000);
	BoundingRadius(5.0);
	SoundName("")
	NoRegisterStep();
	Size(1.0000, 1.0000);
	Hue(255.0000, 255.0000);
	Saturation(255.0000, 255.0000);
	Value(255.0000, 255.0000);
	Alpha(255.0000, 255.0000);
	Spawner()
	{
		Spread()
		{
			PositionX(0.0000,0.0000);
			PositionY(1.2500,1.2500);
			PositionZ(0.0000,0.0000);
		}
		Offset()
		{
			PositionX(0.0000,0.0000);
			PositionY(0.0000,0.0000);
			PositionZ(0.0000,0.0000);
		}
		PositionScale(0.0000,0.0000);
		VelocityScale(5.0000,5.0000);
		InheritVelocityFactor(0.0000,0.0000);
		Size(0, 0.1100, 0.1100);
		Hue(0, 100.0000, 130.0000);
		Saturation(0, 255.0000, 255.0000);
		Value(0, 128.0000, 128.0000);
		Alpha(0, 128.0000, 128.0000);
		StartRotation(0, 0.0000, 0.0000);
		RotationVelocity(0, 0.0000, 0.0000);
		FadeInTime(0.0000);
	}
	Transformer()
	{
		LifeTime(0.4000);
		Position()
		{
			LifeTime(4.0000)
		}
		Size(0)
		{
			LifeTime(0.0250)
			Scale(3.0000);
			Next()
			{
				LifeTime(0.0500)
				Scale(1.5000);
				Next()
				{
					LifeTime(0.1250)
					Scale(1.0000);
				}
			}
		}
		Color(0)
		{
			LifeTime(0.2000)
			Move(0.0000,0.0000,0.0000,255.0000);
			Next()
			{
				LifeTime(0.2000)
				Move(0.0000,0.0000,0.0000,-255.0000);
			}
		}
	}
	Geometry()
	{
		BlendMode("ADDITIVE");
		Type("BILLBOARD");
		Texture("com_sfx_flashring1");
	}
}
