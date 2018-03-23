import frames.timing.*;
import frames.primitives.*;
import frames.processing.*;

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 5;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;
boolean centers = true;
boolean fills = true;
boolean anti = false;
boolean shading = false;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

// 4. Antialiasing Division of nDiv^2. The bigger the number, the better
/*
* Example:
*  nDiv=2 
*     __ __
*    |__|__|
*    |__|__|
*    
*/
int nDiv=5;

void setup() {
  
  //use 2^n to change the dimensions
  size(512, 512, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();
  
  spinningTask = new TimingTask() {
    public void execute() {
      spin();
    }
  };
  scene.registerTask(spinningTask);
  
  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(255);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  // frame.coordinatesOf converts from world to frame
  // here we convert v1 to illustrate the idea
  if (debug) {
    n = n >2 ? n-1 : 9;
    n = n < 9 ? n+1 : 2;
    pushStyle();
    strokeWeight(1);
    stroke(255, 255, 0, 125);
    middlePoints(); //This function draws the squares
    popStyle();    
  }
  
}

void middlePoints(){
    
    int pos= (int)(pow(2,n))/2;
    for(int i = -pos; i<pos; i++){
      for(int j = -pos; j<pos; j++){
        
        
        stroke(0,0,255);
        strokeWeight(0.1);
        float iC=i+0.5;
        float jC=j+0.5;
        if (centers) point(iC, jC);
        float[] points=points_area(i+0.5, j+0.5);
        
        float alpha=aliasing((float)i, (float)j, pointIn(points));
 
        if(fills){
           
          noStroke();
          float [] colors=apply_colors(points);
          
          fill(colors[0], colors[1], colors[2], alpha);
          rect(i,j,1,1);
          
        }
        
      }
    }  
}

float aliasing(float i, float j, boolean in){
  float alpha=0.0;
  
  if(in){ 
    alpha=255.0;
  }
  
  if (!anti){
    return alpha;
  }else{
    float Kdivision=(pow(nDiv, 2));
    float k=1/Kdivision;
    float kB=1/((float)nDiv);
    float cells = 0;
    for(float x=0.0; x<nDiv; x+=1){
      for(float y=0.0; y<nDiv; y+=1){
        float u=i+(x*kB)+k;
        float v=j+(y*kB)+k;
        float[] points=points_area(u, v);
        if (pointIn(points)) cells+=1.0;
      }
 
  }
    return 255*(cells/Kdivision);
  }
  
}

boolean pointIn(float[] points){
    boolean inside1, inside2, inside3;

    inside1 = points[0] < 0.0;
    inside2 = points[1] < 0.0;
    inside3 = points[2] < 0.0;
    
    return ((inside1 == inside2) && (inside2 == inside3));
}

float [] points_area(float px, float py){
    float x1=frame.coordinatesOf(v1).x();
    float y1=frame.coordinatesOf(v1).y();
    float x2=frame.coordinatesOf(v2).x();
    float y2=frame.coordinatesOf(v2).y();
    float x3=frame.coordinatesOf(v3).x();
    float y3=frame.coordinatesOf(v3).y();
    
    float[] points = new float[4];
    points[0]=edgeFunction(px, py, x1, y1, x2, y2);
    points[1]=edgeFunction(px, py, x2, y2, x3, y3);
    points[2]=edgeFunction(px, py, x3, y3, x1, y1); 
    points[3]=edgeFunction(x1, y1, x2, y2, x3, y3);
    return points;
}

float[] apply_colors(float[] points){
  float[] colors= {color(0),color(0),color(0)};
  if(shading){
    colors[0]= round((points[0]/points[3])*255);
    colors[1]= round((points[1]/points[3])*255);
    colors[2]= round((points[2]/points[3])*255);
  }
  return colors;
}

float edgeFunction (float x1, float y1,float x2,float y2, float x3, float y3){
    return (x1 - x3) * (y2 - y3) - (x2 - x3) * (y1 - y3);
}


void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void spin() {
  if (scene.is2D())
    scene.eye().rotate(new Quaternion(new Vector(0, 0, 1), PI / 100), scene.anchor());
  else
    scene.eye().rotate(new Quaternion(yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100), scene.anchor());
}

void keyPressed() {
  if (key == 'g'||key == 'G')  
    gridHint = !gridHint;
  if (key == 't'||key == 'T')
    triangleHint = !triangleHint;
  if (key == 'd'||key == 'D')
    debug = !debug;
    
  if (key == '+') {
    n = n < 9 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
    System.out.println("n:" + n);
  }
  if (key == '-') {
    n = n >2 ? n-1 : 9;    
    frame.setScaling(width/pow( 2, n));
    System.out.println("n:" + n);
  }
  if (key == 'r'||key == 'R')
    randomizeTriangle();
  
  if (key== 'c'||key == 'C')
    centers=!centers;
    
  if (key == 'f'||key == 'F')
    fills=!fills;
    
  if (key == 'a'||key == 'A'){
    anti=!anti;
    System.out.println("Antialiasing: "+anti);
  }
  
  if (key == 'e'||key == 'E') {
    nDiv = nDiv < 10 ? nDiv+1 : 2;
    System.out.println("nDiv:" + nDiv);
  }
  
  if (key == 'Q'||key == 'q') {
    nDiv = nDiv>2 ? nDiv-1 : 10;
    System.out.println("nDiv:" + nDiv);
  }
  
  if (key=='s' || key == 'S'){
    shading=!shading;
    System.out.println("Shading: "+shading); 
  }
  
   if (key == ' '){
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
   }
  if (key == 'y' || key == 'Y')
    yDirection = !yDirection;
    
    
}
