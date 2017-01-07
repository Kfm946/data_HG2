ParticleEmitter("Flare_Down")
{
	MaxParticles(3.0000,3.0000);
	StartDelay(0.0000,0.0000);
	BurstDelay(0.8000, 0.8000);
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
			PositionY(-1.2500,-1.2500);
			PositionZ(0.0000,0.0000);
		}
		Offset()
		{
			PositionX(0.0000,0.0000);
			PositionY(1.2500,1.2500);
			PositionZ(0.0000,0.0000);
		}
		PositionScale(0.0000,0.0000);
		VelocityScale(3.0000,3.0000);
		InheritVelocityFactor(0.0000,0.0000);
		Size(0, 1.0000, 1.0000);
		Red(0, 255.0000, 255.0000);
		Green(0, 255.0000, 255.0000);
		Blue(0, 255.0000, 255.0000);
		Alpha(0, 255.0000, 255.0000);
		StartRotation(0, 0.0000, 0.0000);
		RotationVelocity(0, 0.0000, 0.0000);
		FadeInTime(0.0000);
	}
	Transformer()
	{
		LifeTime(0.8000);
		Position()
		{
			LifeTime(0.8000)
		}
		Size(0)
		{
			LifeTime(0.5000)
		}
		Color(0)
		{
			LifeTime(0.4000)
			Reach(255.0000,255.0000,255.0000,255.0000);
		}
	}
	Geometry()
	{
		BlendMode("NORMAL");
		Type("EMITTER");
		Texture("com_sfx_flashring1");
		ParticleEmitter("Flare_Up")
		{
			MaxParticles(12.0000,12.0000);
			StartDelay(0.0000,0.0000);
			BurstDelay(0.0300, 0.0300);
			BurstCount(1.0000,1.0000);
			MaxLodDist(50.0000);
			MinLodDist(10.0000);
			BoundingRadius(5.0);
			SoundName("")
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
					PositionY(1.0000,1.0000);
					PositionZ(0.0000,0.0000);
				}
				Offset()
				{
					PositionX(0.0000,0.0000);
					PositionY(0.0000,0.0000);
					PositionZ(0.0000,0.0000);
				}
				PositionScale(0.0000,0.0000);
				VelocityScale(0.0000,0.0000);
				InheritVelocityFactor(0.0000,0.0000);
				Size(0, 0.5000, 0.5000);
				Red(0, 0.0000, 0.0000);
				Green(0, 0.0000, 0.0000);
				Blue(0, 255.0000, 255.0000);
				Alpha(0, 128.0000, 128.0000);
				StartRotation(0, 0.0000, 0.0000);
				RotationVelocity(0, 0.0000, 0.0000);
				FadeInTime(0.0000);
			}
			Transformer()
			{
				LifeTime(0.5000);
				Position()
				{
					LifeTime(1.0000)
				}
				Size(0)
				{
					LifeTime(1.5000)
					Scale(0.2500);
				}
				Color(0)
				{
					LifeTime(0.2000)
					Move(0.0000,0.0000,0.0000,128.0000);
					Next()
					{
						LifeTime(0.4000)
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
	}
	ParticleEmitter("Flare_BackUp")
	{
		MaxParticles(3.0000,3.0000);
		StartDelay(0.4000,0.4000);
		BurstDelay(0.8000, 0.8000);
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
			VelocityScale(3.0000,3.0000);
			InheritVelocityFactor(0.0000,0.0000);
			Size(0, 1.0000, 1.0000);
			Red(0, 255.0000, 255.0000);
			Green(0, 255.0000, 255.0000);
			Blue(0, 255.0000, 255.0000);
			Alpha(0, 255.0000, 255.0000);
			StartRotation(0, 0.0000, 0.0000);
			RotationVelocity(0, 0.0000, 0.0000);
			FadeInTime(0.0000);
		}
		Transformer()
		{
			LifeTime(0.8000);
			Position()
			{
				LifeTime(0.8000)
			}
			Size(0)
			{
				LifeTime(0.5000)
			}
			Color(0)
			{
				LifeTime(0.4000)
				Reach(255.0000,255.0000,255.0000,255.0000);
			}
		}
		Geometry()
		{
			BlendMode("NORMAL");
			Type("EMITTER");
			Texture("com_sfx_flashring1");
			ParticleEmitter("Flare_Up")
			{
				MaxParticles(12.0000,12.0000);
				StartDelay(0.0000,0.0000);
				BurstDelay(0.0300, 0.0300);
				BurstCount(1.0000,1.0000);
				MaxLodDist(50.0000);
				MinLodDist(10.0000);
				BoundingRadius(5.0);
				SoundName("")
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
						PositionY(1.0000,1.0000);
						PositionZ(0.0000,0.0000);
					}
					Offset()
					{
						PositionX(0.0000,0.0000);
						PositionY(0.0000,0.0000);
						PositionZ(0.0000,0.0000);
					}
					PositionScale(0.0000,0.0000);
					VelocityScale(0.0000,0.0000);
					InheritVelocityFactor(0.0000,0.0000);
					Size(0, 0.5000, 0.5000);
					Red(0, 0.0000, 0.0000);
					Green(0, 0.0000, 0.0000);
					Blue(0, 255.0000, 255.0000);
					Alpha(0, 128.0000, 128.0000);
					StartRotation(0, 0.0000, 0.0000);
					RotationVelocity(0, 0.0000, 0.0000);
					FadeInTime(0.0000);
				}
				Transformer()
				{
					LifeTime(0.5000);
					Position()
					{
						LifeTime(1.0000)
					}
					Size(0)
					{
						LifeTime(1.5000)
						Scale(0.2500);
					}
					Color(0)
					{
						LifeTime(0.2000)
						Move(0.0000,0.0000,0.0000,128.0000);
						Next()
						{
							LifeTime(0.4000)
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
		}
		ParticleEmitter("Flare_Up")
		{
			MaxParticles(3.0000,3.0000);
			StartDelay(0.0000,0.0000);
			BurstDelay(0.8000, 0.8000);
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
					PositionY(1.2500,1.2500);
					PositionZ(0.0000,0.0000);
				}
				PositionScale(0.0000,0.0000);
				VelocityScale(3.0000,3.0000);
				InheritVelocityFactor(0.0000,0.0000);
				Size(0, 1.0000, 1.0000);
				Red(0, 255.0000, 255.0000);
				Green(0, 255.0000, 255.0000);
				Blue(0, 255.0000, 255.0000);
				Alpha(0, 255.0000, 255.0000);
				StartRotation(0, 0.0000, 0.0000);
				RotationVelocity(0, 0.0000, 0.0000);
				FadeInTime(0.0000);
			}
			Transformer()
			{
				LifeTime(0.8000);
				Position()
				{
					LifeTime(0.8000)
				}
				Size(0)
				{
					LifeTime(0.5000)
				}
				Color(0)
				{
					LifeTime(0.4000)
					Reach(255.0000,255.0000,255.0000,255.0000);
				}
			}
			Geometry()
			{
				BlendMode("NORMAL");
				Type("EMITTER");
				Texture("com_sfx_flashring1");
				ParticleEmitter("Flare_Up")
				{
					MaxParticles(12.0000,12.0000);
					StartDelay(0.0000,0.0000);
					BurstDelay(0.0300, 0.0300);
					BurstCount(1.0000,1.0000);
					MaxLodDist(50.0000);
					MinLodDist(10.0000);
					BoundingRadius(5.0);
					SoundName("")
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
							PositionY(1.0000,1.0000);
							PositionZ(0.0000,0.0000);
						}
						Offset()
						{
							PositionX(0.0000,0.0000);
							PositionY(0.0000,0.0000);
							PositionZ(0.0000,0.0000);
						}
						PositionScale(0.0000,0.0000);
						VelocityScale(0.0000,0.0000);
						InheritVelocityFactor(0.0000,0.0000);
						Size(0, 0.5000, 0.5000);
						Red(0, 0.0000, 0.0000);
						Green(0, 0.0000, 0.0000);
						Blue(0, 255.0000, 255.0000);
						Alpha(0, 100.0000, 128.0000);
						StartRotation(0, 0.0000, 0.0000);
						RotationVelocity(0, 0.0000, 0.0000);
						FadeInTime(0.0000);
					}
					Transformer()
					{
						LifeTime(0.5000);
						Position()
						{
							LifeTime(1.0000)
						}
						Size(0)
						{
							LifeTime(1.5000)
							Scale(0.2500);
						}
						Color(0)
						{
							LifeTime(0.2000)
							Move(0.0000,0.0000,0.0000,128.0000);
							Next()
							{
								LifeTime(0.4000)
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
			}
			ParticleEmitter("Flare_BackDown")
			{
				MaxParticles(3.0000,3.0000);
				StartDelay(0.4000,0.4000);
				BurstDelay(0.8000, 0.8000);
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
						PositionY(-1.2500,-1.2500);
						PositionZ(0.0000,0.0000);
					}
					Offset()
					{
						PositionX(0.0000,0.0000);
						PositionY(2.5000,2.5000);
						PositionZ(0.0000,0.0000);
					}
					PositionScale(0.0000,0.0000);
					VelocityScale(3.0000,3.0000);
					InheritVelocityFactor(0.0000,0.0000);
					Size(0, 1.0000, 1.0000);
					Red(0, 255.0000, 255.0000);
					Green(0, 255.0000, 255.0000);
					Blue(0, 255.0000, 255.0000);
					Alpha(0, 255.0000, 255.0000);
					StartRotation(0, 0.0000, 0.0000);
					RotationVelocity(0, 0.0000, 0.0000);
					FadeInTime(0.0000);
				}
				Transformer()
				{
					LifeTime(0.8000);
					Position()
					{
						LifeTime(0.8000)
					}
					Size(0)
					{
						LifeTime(0.5000)
					}
					Color(0)
					{
						LifeTime(0.4000)
						Reach(255.0000,255.0000,255.0000,255.0000);
					}
				}
				Geometry()
				{
					BlendMode("NORMAL");
					Type("EMITTER");
					Texture("com_sfx_flashring1");
					ParticleEmitter("Flare_Up")
					{
						MaxParticles(12.0000,12.0000);
						StartDelay(0.0000,0.0000);
						BurstDelay(0.0300, 0.0300);
						BurstCount(1.0000,1.0000);
						MaxLodDist(50.0000);
						MinLodDist(10.0000);
						BoundingRadius(5.0);
						SoundName("")
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
								PositionY(1.0000,1.0000);
								PositionZ(0.0000,0.0000);
							}
							Offset()
							{
								PositionX(0.0000,0.0000);
								PositionY(0.0000,0.0000);
								PositionZ(0.0000,0.0000);
							}
							PositionScale(0.0000,0.0000);
							VelocityScale(0.0000,0.0000);
							InheritVelocityFactor(0.0000,0.0000);
							Size(0, 0.5000, 0.5000);
							Red(0, 0.0000, 0.0000);
							Green(0, 0.0000, 0.0000);
							Blue(0, 255.0000, 255.0000);
							Alpha(0, 128.0000, 128.0000);
							StartRotation(0, 0.0000, 0.0000);
							RotationVelocity(0, 0.0000, 0.0000);
							FadeInTime(0.0000);
						}
						Transformer()
						{
							LifeTime(0.5000);
							Position()
							{
								LifeTime(1.0000)
							}
							Size(0)
							{
								LifeTime(1.5000)
								Scale(0.2500);
							}
							Color(0)
							{
								LifeTime(0.2000)
								Move(0.0000,0.0000,0.0000,128.0000);
								Next()
								{
									LifeTime(0.4000)
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
				}
				ParticleEmitter("ChargeGlow")
				{
					MaxParticles(60.0000,60.0000);
					StartDelay(0.0000,0.0000);
					BurstDelay(0.0400, 0.0400);
					BurstCount(1.0000,1.0000);
					MaxLodDist(1100.0000);
					MinLodDist(1000.0000);
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
						Circle()
						{
							PositionX(-10.0000,10.0000);
							PositionY(-10.0000,10.0000);
							PositionZ(-10.0000,10.0000);
						}
						Offset()
						{
							PositionX(0.0000,0.0000);
							PositionY(1.2500,1.2500);
							PositionZ(0.0000,0.0000);
						}
						PositionScale(1.0000,1.0000);
						VelocityScale(-2.0000,-2.0000);
						InheritVelocityFactor(0.0000,0.0000);
						Size(0, 0.0050, 0.0100);
						Hue(0, 0.0000, 0.0000);
						Saturation(0, 255.0000, 255.0000);
						Value(0, 255.0000, 255.0000);
						Alpha(0, 64.0000, 64.0000);
						StartRotation(0, 0.0000, 0.0000);
						RotationVelocity(0, -2.0000, 0.0000);
						FadeInTime(0.0000);
					}
					Transformer()
					{
						LifeTime(0.1500);
						Position()
						{
							LifeTime(0.1500)
							Scale(0.0000);
						}
						Size(0)
						{
							LifeTime(0.1500)
							Scale(5.0000);
						}
						Color(0)
						{
							LifeTime(0.1500)
							Move(255.0000,0.0000,0.0000,-64.0000);
						}
					}
					Geometry()
					{
						BlendMode("ADDITIVE");
						Type("SPARK");
						SparkLength(0.1000);
						Texture("com_sfx_flashball1");
						ParticleEmitter("Smoke")
						{
							MaxParticles(15.0000,15.0000);
							StartDelay(0.0000,0.0000);
							BurstDelay(0.1000, 0.2000);
							BurstCount(1.0000,1.0000);
							MaxLodDist(1000.0000);
							MinLodDist(800.0000);
							BoundingRadius(5.0);
							SoundName("")
							Size(1.0000, 1.0000);
							Hue(255.0000, 255.0000);
							Saturation(255.0000, 255.0000);
							Value(255.0000, 255.0000);
							Alpha(255.0000, 255.0000);
							Spawner()
							{
								Spread()
								{
									PositionX(-1.0000,1.0000);
									PositionY(-1.0000,1.0000);
									PositionZ(-1.0000,1.0000);
								}
								Offset()
								{
									PositionX(0.0000,0.0000);
									PositionY(0.0000,0.0000);
									PositionZ(0.0000,0.0000);
								}
								PositionScale(0.0000,0.0000);
								VelocityScale(0.1000,0.1000);
								InheritVelocityFactor(0.0000,0.0000);
								Size(0, 0.6000, 0.9000);
								Red(0, 240.0000, 255.0000);
								Green(0, 240.0000, 255.0000);
								Blue(0, 240.0000, 255.0000);
								Alpha(0, 0.0000, 0.0000);
								StartRotation(0, -50.0000, 0.0000);
								RotationVelocity(0, -50.0000, 50.0000);
								FadeInTime(0.0000);
							}
							Transformer()
							{
								LifeTime(10.0000);
								Position()
								{
									LifeTime(3.0000)
								}
								Size(0)
								{
									LifeTime(3.0000)
									Scale(3.0000);
								}
								Color(0)
								{
									LifeTime(0.5000)
									Move(255.0000,255.0000,255.0000,255.0000);
									Next()
									{
										LifeTime(10.0000)
										Reach(255.0000,255.0000,255.0000,255.0000);
										Next()
										{
											LifeTime(0.0000)
											Reach(255.0000,255.0000,255.0000,0.0000);
										}
									}
								}
							}
							Geometry()
							{
								BlendMode("NORMAL");
								Type("PARTICLE");
								Texture("underlitesmoke2");
							}
						}
					}
					ParticleEmitter("Ring")
					{
						MaxParticles(1.0000,1.0000);
						StartDelay(0.0000,0.0000);
						BurstDelay(1.0000, 1.0000);
						BurstCount(1.0000,1.0000);
						MaxLodDist(1100.0000);
						MinLodDist(1000.0000);
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
							Circle()
							{
								PositionX(0.0000,0.0000);
								PositionY(0.0000,0.0000);
								PositionZ(0.0000,0.0000);
							}
							Offset()
							{
								PositionX(0.0000,0.0000);
								PositionY(1.2500,1.2500);
								PositionZ(0.0000,0.0000);
							}
							PositionScale(0.0000,0.0000);
							VelocityScale(0.0000,0.0000);
							InheritVelocityFactor(0.0000,0.0000);
							Size(0, 5.0000, 5.0000);
							Hue(0, 170.0000, 170.0000);
							Saturation(0, 255.0000, 255.0000);
							Value(0, 255.0000, 255.0000);
							Alpha(0, 0.0000, 0.0000);
							StartRotation(0, 0.0000, 0.0000);
							RotationVelocity(0, -2.0000, 0.0000);
							FadeInTime(0.0000);
						}
						Transformer()
						{
							LifeTime(2.0000);
							Position()
							{
								LifeTime(2.0000)
							}
							Size(0)
							{
								LifeTime(3.0000)
								Scale(0.0000);
							}
							Color(0)
							{
								LifeTime(1.0000)
								Move(0.0000,0.0000,0.0000,64.0000);
								Next()
								{
									LifeTime(1.0000)
									Move(0.0000,0.0000,0.0000,-64.0000);
								}
							}
						}
						Geometry()
						{
							BlendMode("ADDITIVE");
							Type("PARTICLE");
							Texture("com_sfx_flashring1");
							ParticleEmitter("Smoke")
							{
								MaxParticles(15.0000,15.0000);
								StartDelay(0.0000,0.0000);
								BurstDelay(0.1000, 0.2000);
								BurstCount(1.0000,1.0000);
								MaxLodDist(1000.0000);
								MinLodDist(800.0000);
								BoundingRadius(5.0);
								SoundName("")
								Size(1.0000, 1.0000);
								Hue(255.0000, 255.0000);
								Saturation(255.0000, 255.0000);
								Value(255.0000, 255.0000);
								Alpha(255.0000, 255.0000);
								Spawner()
								{
									Spread()
									{
										PositionX(-1.0000,1.0000);
										PositionY(-1.0000,1.0000);
										PositionZ(-1.0000,1.0000);
									}
									Offset()
									{
										PositionX(0.0000,0.0000);
										PositionY(0.0000,0.0000);
										PositionZ(0.0000,0.0000);
									}
									PositionScale(0.0000,0.0000);
									VelocityScale(0.1000,0.1000);
									InheritVelocityFactor(0.0000,0.0000);
									Size(0, 0.6000, 0.9000);
									Red(0, 240.0000, 255.0000);
									Green(0, 240.0000, 255.0000);
									Blue(0, 240.0000, 255.0000);
									Alpha(0, 0.0000, 0.0000);
									StartRotation(0, -50.0000, 0.0000);
									RotationVelocity(0, -50.0000, 50.0000);
									FadeInTime(0.0000);
								}
								Transformer()
								{
									LifeTime(10.0000);
									Position()
									{
										LifeTime(3.0000)
									}
									Size(0)
									{
										LifeTime(3.0000)
										Scale(3.0000);
									}
									Color(0)
									{
										LifeTime(0.5000)
										Move(255.0000,255.0000,255.0000,255.0000);
										Next()
										{
											LifeTime(10.0000)
											Reach(255.0000,255.0000,255.0000,255.0000);
											Next()
											{
												LifeTime(0.0000)
												Reach(255.0000,255.0000,255.0000,0.0000);
											}
										}
									}
								}
								Geometry()
								{
									BlendMode("NORMAL");
									Type("PARTICLE");
									Texture("underlitesmoke2");
								}
							}
						}
					}
				}
			}
		}
	}
}
