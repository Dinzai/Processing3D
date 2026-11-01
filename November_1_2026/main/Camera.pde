
//This is the camera for the program

class Camera
{

  Camera()
  {
    cameraSpeed = 500;
    SetViewArea(screenWidth, screenHeight);
  }

  void SetViewArea(int viewWidth, int viewHeight)
  {
    this.viewWidth = viewWidth;
    this.viewHeight = viewHeight;
  }

  void Translate(Vector3 direction)
  {
    t.position.x += direction.x * cameraSpeed * deltaTime;
    t.position.y += direction.y * cameraSpeed * deltaTime;
    t.position.z += direction.z * cameraSpeed * deltaTime;
  }

  void SetPosition(Vector3 position)
  {
    t.position.x = position.x;
    t.position.y = position.y;
    t.position.z = position.z;
  }

  void SetScale(Vector3 scale)
  {
    t.scale.x = scale.x;
    t.scale.y = scale.y;
    t.scale.z = scale.z;
  }
  
  void SetRotation(Vector3 rotation)
  {
    t.rotation = rotation;
  }

  void SetRotationX(float amount)
  {
    t.rotation.x = amount;
  }
  
  void SetRotationY(float amount)
  {
    t.rotation.y = amount;
  }
  
  void SetRotationZ(float amount)
  {
    t.rotation.z = amount;
  }


  Matrix GetMatrix()
  {
    Matrix m = new Matrix();

    // Move the camera's origin to the screen center
    m = m.Translate(viewWidth * 0.5, viewHeight * 0.5, 0);

    // Apply inverse camera scale
    m = m.Scale(1.0 / t.scale.x, 1.0 / t.scale.y, 1.0 / t.scale.z);

    // Apply inverse camera rotation
    m = m.RotateX(t.rotation.x);
    m = m.RotateY(t.rotation.y);
    m = m.RotateZ(t.rotation.z);

    // Move the world relative to the camera
    m = m.Translate(-t.position.x, -t.position.y, -t.position.z);

    return m;
  }

  Transform t = new Transform();
  float cameraSpeed;

  int viewWidth;
  int viewHeight;
}
