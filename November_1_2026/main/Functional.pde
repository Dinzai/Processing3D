//This is where all global functions will be stored

//alocate space for the hashmap
void InitProgram()
{
  camera = new Camera();

  for (Layers layer : Layers.values())
  {
    objectsToRender.put(layer, new ArrayList<>());
  }
}

void AddToScene(Layers layer, IDrawable d)
{
  objectsToRender.get(layer).add(d);
}

void MakeEntity(Vector3 position, Vector3 scale, Vector3 rotation, float radius, Vector3 colour, int vertCount, Layers layer)
{
  Entity temp = new Entity();
  temp.shape.t.position = position;
  temp.shape.t.scale = scale;
  temp.shape.t.rotation.x = rotation.x;
  temp.shape.t.rotation.y = rotation.y;
  temp.shape.t.rotation.z = rotation.z;
  temp.shape.radius = radius;
  temp.shape.SetVerts(vertCount);
  temp.shape.SetColor(colour.x, colour.y, colour.z);
  AddToScene(layer, temp);
}

void CalculateDeltaTime()
{
  float currentTime = millis();
  deltaTime = (currentTime - previousTime) / 1000.0;
  previousTime = currentTime;
}

void Draw(IDrawable d, Matrix m)
{
  Vector3 colour = d.GetColour();

  int verts = d.GetShape().numberOfVerts;
  float radius = d.GetShape().radius;

  float thetaStep = TWO_PI / verts;
  float phiStep = PI / verts;



  for (int j = 0; j < verts; j++)
  {
    float phi1 = j * phiStep;
    float phi2 = (j + 1) * phiStep;

    beginShape(TRIANGLE_STRIP);
    fill(colour.x, colour.y, colour.z);

    for (int i = 0; i <= verts; i++)
    {
      float theta = i * thetaStep;

      // First latitude
      float x1 = radius * sin(phi1) * cos(theta);
      float y1 = radius * sin(phi1) * sin(theta);
      float z1 = radius * cos(phi1);

      // Second latitude
      float x2 = radius * sin(phi2) * cos(theta);
      float y2 = radius * sin(phi2) * sin(theta);
      float z2 = radius * cos(phi2);

      Vector3 p1 = m.TransformPoint(new Vector3(x1, y1, z1));
      Vector3 p2 = m.TransformPoint(new Vector3(x2, y2, z2));

      vertex(p1.x, p1.y, p1.z);
      vertex(p2.x, p2.y, p2.z);
    }

    endShape();
  }
}


void RenderAll()
{

  Matrix view = camera.GetMatrix();

  for (Layers layer : Layers.values())
  {
    for (IDrawable d : objectsToRender.get(layer))
    {
      Matrix modelMatrix = d.GetTransform().GetMatrix();
      Matrix finalMatrix = view.Mult(modelMatrix);
      Draw(d, finalMatrix);
    }
  }
}

void CameraMovement()
{
  float yaw = currentRotation.y;

  Vector3 forward = new Vector3(
    -sin(yaw),
    0,
    -cos(yaw)
    );

  Vector3 right = new Vector3(
    cos(yaw),
    0,
    -sin(yaw)
    );

  if (keyPressed)
  {
    if (key == 'w')
      camera.Translate(forward);

    if (key == 's')
      camera.Translate(new Vector3(-forward.x, 0, -forward.z));

    if (key == 'a')
      camera.Translate(new Vector3(-right.x, 0, -right.z));

    if (key == 'd')
      camera.Translate(right);

    if (key == 'q')
      camera.Translate(new Vector3(0, -1, 0));

    if (key == 'e')
      camera.Translate(new Vector3(0, 1, 0));
  }
}

void UpdateMouseLook()
{
  if (!mouseLocked || mouseRobot == null)
    return;

  PointerInfo pointer = MouseInfo.getPointerInfo();

  if (pointer == null)
    return;

  Point mousePosition = pointer.getLocation();

  // Get Processing's P3D window
  GLWindow window = (GLWindow) surface.getNative();

  // Calculate the actual center of the drawing area
  int centerX = window.getX()
              + window.getInsets().getLeftWidth()
              + width / 2;

  int centerY = window.getY()
              + window.getInsets().getTopHeight()
              + height / 2;

  // First frame: center mouse without rotating
  if (mouseJustLocked)
  {
    mouseRobot.mouseMove(centerX, centerY);
    mouseJustLocked = false;
    return;
  }

  // Calculate movement relative to center
  float deltaX = mousePosition.x - centerX;
  float deltaY = mousePosition.y - centerY;

  if (deltaX == 0 && deltaY == 0)
    return;

  // Apply rotation
  currentRotation.y += deltaX * mouseSensitivity;
  currentRotation.x -= deltaY * mouseSensitivity;

  // Prevent vertical flipping
  currentRotation.x = constrain(
    currentRotation.x,
    -HALF_PI + 0.01,
    HALF_PI - 0.01
  );

  camera.SetRotation(currentRotation);

  // Return mouse to center
  mouseRobot.mouseMove(centerX, centerY);
}
