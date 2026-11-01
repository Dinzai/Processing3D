
//Brett Rogers November 1st, 2026

void settings()
{
  size(screenWidth, screenHeight, P3D);
}

void setup()
{
  //In Functional.pde
  InitProgram();

  try
  {
    mouseRobot = new Robot();
  }
  catch (AWTException e)
  {
    println("Failed to initialize mouse robot");
  }
  noCursor();

  //In Enums.pde
  Layers layer = Layers.BASE_ENTITY;

  // Green sphere directly ahead
  MakeEntity(new Vector3(0, 0, -200), new Vector3(1, 1, 1), new Vector3(0, 0, 0), 30, new Vector3(100, 200, 100), 16, layer);

  // Blue sphere to the right
  MakeEntity(new Vector3(100, 0, -300), new Vector3(1, 1, 1), new Vector3(0, 0, 0),30, new Vector3(100, 100, 200), 16, layer);
  
}

void draw()
{
  background(110);
  //All Functions found under Functional.pde

  CalculateDeltaTime();
  CameraMovement();
  UpdateMouseLook();
  RenderAll();
}
