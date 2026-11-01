

class Entity implements IDrawable
{
  Entity()
  {
    
  }
  
  Shape GetShape()
  {
    return shape;
  }
  
  Transform GetTransform()
  {
    return shape.t;
  }
  
  Vector3 GetColour()
  {
    return shape.colour;
  }
  
  //Shape is in the Matrix.pde
  Shape shape = new Shape();
  
}
