Effect("Lightning")
{
	Enable(1);
	Color(255, 255, 255);
	SunlightFadeFactor(0.1);
	SkyDomeDarkenFactor(0.5);
	BrightnessMin(0.5);
	FadeTime(0.2);
	TimeBetweenFlashesMinMax(15.0, 30.0);
	TimeBetweenSubFlashesMinMax(0.01, 0.5);
	NumSubFlashesMinMax(4, 6);
	HorizonAngleMinMax(30, 60);
	SoundCrack("kam_amb_thunder");
	SoundSubCrack("kam_amb_thundersub");
}

Effect("FogCloud")
{
	Enable(1);
	Texture("fluffy");
	Range(40.0, 80.0);
	Color(112,120,122, 192);
	Velocity(1.0, 2.0);
	Rotation(0.05);
	Height(25.0);
	ParticleSize(50.0);
	ParticleDensity(80.0);
}

Effect("Water")
{

	// general parameters
	PatchDivisions(4,4);

	// ocean parameters
	OceanEnable(0);

	// water event parameters
	WaterRingColor(148, 170, 192,255);
	WaterWakeColor(192, 192, 192,255);
	WaterSplashColor((192, 192, 192,255);
	
	DisableLowRes();

	// PC parameters
	PC()
	{
		Tile(2.0,2.0);
		MainTexture("dag1_water");
		LODDecimation(1);
		RefractionColor(75, 80, 81, 225);
		ReflectionColor(75,83,84,225);
		UnderwaterColor(78, 81, 81, 125);
		FresnelMinMax(0.1,0.4);
		FarSceneRange(50)

		NormalMapTextures("water_normalmap_",16,8.0);
		BumpMapTextures("water_bumpmap_",16,8.0);
		SpecularMaskTextures("water_specularmask_",25, 2);
		SpecularMaskTile(4.0, 4.0);
		Velocity(0.01,0.01);

	}
	
}

Effect("Precipitation")
{
   Enable(1);
   Type("Quads");
   Texture("fx_pollen");
   ParticleSize(0.01);
   Color(200, 210, 213);
   Range(25.0);
   Velocity(0.0);
   VelocityRange(0.3);
   PC()
   {
      ParticleDensity(20.0);
   }
   ParticleDensityRange(10.0);
   CameraCrossVelocityScale(0.7);
   CameraAxialVelocityScale(0.8);
   AlphaMinMax(0.15, 0.25);
   RotationRange(2.0);
}

Effect("HDR")
{
	Enable(1)
	DownSizeFactor(0.25)
	NumBloomPasses(3)
	MaxTotalWeight(1.0)
	GlowThreshold(0.5)

	GlowFactor(1.0)
}
