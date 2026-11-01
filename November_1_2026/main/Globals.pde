//This is where All global variables will be stored

import java.util.HashMap;
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.Point;
import java.awt.MouseInfo;
import java.awt.PointerInfo;
import com.jogamp.newt.opengl.GLWindow;


int screenWidth = 800;
int screenHeight = 600;

float deltaTime;
float previousTime = 0;

Robot mouseRobot;
boolean mouseLocked = true;
Vector3 currentRotation = new Vector3(0, 0, 0);
boolean mouseJustLocked = true;
float mouseSensitivity = 0.002;
Camera camera;

HashMap<Layers, ArrayList<IDrawable>> objectsToRender = new HashMap<>();
