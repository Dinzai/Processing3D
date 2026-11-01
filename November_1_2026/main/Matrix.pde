
//This is where Matrix, Vectors, and shapes are stored

class Vector3
{

  Vector3(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    //default w to 1
    this.w = 1;
  }

  float x;
  float y;
  float z;
  float w;
}

class Shape
{

  Shape()
  {
  }

  void SetColor(float r, float g, float b)
  {
    colour = new Vector3(r, g, b);
  }

  void SetVerts(int num)
  {
    numberOfVerts = num;
  }

  void SetRadius(float r)
  {
    radius = r;
  }

  int numberOfVerts = 0;
  float radius = 0;
  Vector3 colour = new Vector3(0, 0, 0);
  Transform t = new Transform();
}

class Transform
{

  Transform()
  {
    scale = new Vector3(1, 1, 1);
    rotation = new Vector3(0, 0, 0);
    position = new Vector3(0, 0, 0);
    origin = new Vector3(0, 0, 0);
  }

  Matrix GetMatrix()
  {
    Matrix m = new Matrix();

    m = m.Translate(-origin.x, -origin.y, -origin.z);
    m = m.Scale(scale.x, scale.y, scale.z);
    m = m.RotateX(rotation.x);
    m = m.RotateY(rotation.y);
    m = m.RotateZ(rotation.z);
    m = m.Translate(position.x, position.y, position.z);

    return m;
  }

  Vector3 scale = new Vector3(1, 1, 1);
  Vector3 rotation = new Vector3(0, 0, 0);
  Vector3 position = new Vector3(0, 0, 0);
  Vector3 origin = new Vector3(0, 0, 0);
}



class Matrix
{

  Matrix()
  {
    Identity();
  }

  Matrix Mult(Matrix n)
  {
    Matrix result = new Matrix();
    //First row
    result.m00 = m00 * n.m00 + m01 * n.m10 + m02 * n.m20 + m03 * n.m30;
    result.m01 = m00 * n.m01 + m01 * n.m11 + m02 * n.m21 + m03 * n.m31;
    result.m02 = m00 * n.m02 + m01 * n.m12 + m02 * n.m22 + m03 * n.m32;
    result.m03 = m00 * n.m03 + m01 * n.m13 + m02 * n.m23 + m03 * n.m33;
    //second row
    result.m10 = m10 * n.m00 + m11 * n.m10 + m12 * n.m20 + m13 * n.m30;
    result.m11 = m10 * n.m01 + m11 * n.m11 + m12 * n.m21 + m13 * n.m31;
    result.m12 = m10 * n.m02 + m11 * n.m12 + m12 * n.m22 + m13 * n.m32;
    result.m13 = m10 * n.m03 + m11 * n.m13 + m12 * n.m23 + m13 * n.m33;
    //Third Row
    result.m20 = m20 * n.m00 + m21 * n.m10 + m22 * n.m20 + m23 * n.m30;
    result.m21 = m20 * n.m01 + m21 * n.m11 + m22 * n.m21 + m23 * n.m31;
    result.m22 = m20 * n.m02 + m21 * n.m12 + m22 * n.m22 + m23 * n.m32;
    result.m23 = m20 * n.m03 + m21 * n.m13 + m22 * n.m23 + m23 * n.m33;
    //Fourth Row
    result.m30 = m30 * n.m00 + m31 * n.m10 + m32 * n.m20 + m33 * n.m30;
    result.m31 = m30 * n.m01 + m31 * n.m11 + m32 * n.m21 + m33 * n.m31;
    result.m32 = m30 * n.m02 + m31 * n.m12 + m32 * n.m22 + m33 * n.m32;
    result.m33 = m30 * n.m03 + m31 * n.m13 + m32 * n.m23 + m33 * n.m33;

    return result;
  }

  void Identity()
  {
    m00 = 1;
    m01 = 0;
    m02 = 0;
    m03 = 0;
    //
    m10 = 0;
    m11 = 1;
    m12 = 0;
    m13 = 0;
    //
    m20 = 0;
    m21 = 0;
    m22 = 1;
    m23 = 0;

    m30 = 0;
    m31 = 0;
    m32 = 0;
    m33 = 1;
  }

  Vector3 TransformPoint(Vector3 point)
  {
    Vector3 outVector = new Vector3(0, 0, 0);
    outVector.x = m00 * point.x + m01 * point.y + m02 * point.z + m03;
    outVector.y = m10 * point.x + m11 * point.y + m12 * point.z + m13;
    outVector.z = m20 * point.x + m21 * point.y + m22 * point.z + m23;
    return outVector;
  }

  //calculate the Determinant

  float Determinant()
  {
    float A = m00 * (m11 * m22 - m12 * m21);
    float B = m01 * (m10 * m22 - m12 * m20);
    float C = m02 * (m10 * m21 - m11 * m20);

    return A - B + C;
  }


  Matrix Inverse()
  {

    Matrix result = new Matrix();
    float determinant = Determinant();
    if (determinant == 0)
    {
      print("Oops, divided by 0");
    }

    //Patern
    /*
          //remove 1st row, 1st column, [ +  -  +]
     //remove 1st row, 2nd column, [ -  +  -]
     //remove 1st row, 3rd column, [ +  -  +]
     
     //remove 2nd row, 1st column, [ -  +  -]
     //remove 2nd row, 2nd column, [ +  -  +]
     //remove 2nd row, 3rd column, [ -  +  -]
     
     //remove 3rd row, 1st column, [ +  -  +]
     //remove 3rd row, 2nd column, [ -  +  -]
     //remove 3rd row, 3rd column, [ +  -  +]
     
     */

    //drop the 4th row and 4th column
    /*
          [ m00, m01, m02 ]
     [ m10, m11, m12 ]
     [ m20, m21, m22 ]
     
     */
    //remove the first row, and first collumn

    /*
       
     [ m11, m12 ]
     [ m21, m22 ]
     
     */

    float c00 = m11 * m22 - m12 * m21;

    //remove the first row, and second collumn

    /*
              
     [ m10, m12 ]
     [ m20, m22 ]
     */


    float c01 = -(m10 * m22 - m12 * m20);


    //remove the first row, and third collumn

    /*
              
     
     [ m10, m11 ]
     [ m20, m21 ]
     */

    float c02 = m10 * m21 - m11 * m20;


    //original matrix for reference
    /*
          [ m00, m01, m02 ]
     [ m10, m11, m12 ]
     [ m20, m21, m22 ]
     
     */

    //remove the second row, and first collumn

    /*
       
     [ m01, m02 ]
     [ m21, m22 ]
     
     */


    float c10 = -(m01 * m22 - m02 * m21);

    //remove the second row, and second collumn

    /*
       
     [ m00,  m02 ]
     [ m20,  m22 ]
     
     */

    float c11 = m00 * m22 - m02 * m20;

    //remove the second row, and third collumn

    /*
       
     [ m00, m01 ]
     [ m20, m21 ]
     
     */

    float c12 = -(m00 * m21 - m01 * m20);

    //original matrix for reference
    /*
          [ m00, m01, m02 ]
     [ m10, m11, m12 ]
     [ m20, m21, m22 ]
     
     */

    //remove the third row, and first collumn

    /*
       
     [  m01, m02 ]
     [  m11, m12 ]
     
     
     */
    float c20 = m01 * m12 - m02 * m11;

    //third row, 2nd collumn
    /*
          [ m00, m02 ]
     [ m10, m12 ]
     
     */
    float c21 = -(m00 * m12 - m02 * m10);

    //third row, third collumn
    /*
          [ m00, m01 ]
     [ m10, m11 ]
     
     */

    float c22 = m00 * m11 - m01 * m10;


    result.m00 = c00 / determinant;
    result.m01 = c10 / determinant;
    result.m02 = c20 / determinant;

    result.m10 = c01 / determinant;
    result.m11 = c11 / determinant;
    result.m12 = c21 / determinant;

    result.m20 = c02 / determinant;
    result.m21 = c12 / determinant;
    result.m22 = c22 / determinant;

    result.m03 = -(result.m00 * m03 + result.m01 * m13 + result.m02 * m23);
    result.m13 = -(result.m10 * m03 + result.m11 * m13 + result.m12 * m23);
    result.m23 = -(result.m20 * m03 + result.m21 * m13 + result.m22 * m23);

    return result;
  }

  Matrix Translate(float tx, float ty, float tz)
  {
    Matrix t = new Matrix();
    t.m03 = tx;
    t.m13 = ty;
    t.m23 = tz;

    return t.Mult(this);
  }

  Matrix RotateX(float angle)
  {
    Matrix r = new Matrix();

    float c = cos(angle);
    float s = sin(angle);

    r.m11 = c;
    r.m12 = -s;
    r.m21 = s;
    r.m22 = c;

    return r.Mult(this);
  }

  Matrix RotateY(float angle)
  {
    Matrix r = new Matrix();

    float c = cos(angle);
    float s = sin(angle);

    r.m00 = c;
    r.m02 = s;
    r.m20 = -s;
    r.m22 = c;

    return r.Mult(this);
  }

  Matrix RotateZ(float angle)
  {
    Matrix r = new Matrix();

    float c = cos(angle);
    float s = sin(angle);

    r.m00 = c;
    r.m01 = -s;
    r.m10 = s;
    r.m11 = c;

    return r.Mult(this);
  }

  Matrix Scale(float sx, float sy, float sz)
  {
    Matrix s = new Matrix();
    s.m00 = sx;
    s.m11 = sy;
    s.m22 = sz;

    return s.Mult(this);
  }

  //
  float m00;
  float m01;
  float m02;
  float m03;
  //
  float m10;
  float m11;
  float m12;
  float m13;
  //
  float m20;
  float m21;
  float m22;
  float m23;
  //default values for bottom matrix
  float m30 = 0;
  float m31 = 0;
  float m32 = 0;
  float m33 = 1;
}
