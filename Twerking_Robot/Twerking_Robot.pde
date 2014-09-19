/*
Jesse Oberstein
Computer Graphics
Twerking Robot
*/

// A robot created from the Robot class.
Robot rob;
// An array of bushes.
Bush[] bushes = new Bush[3];
// An array of timers for how long each bush has until its fire runs out.
int[] fireTimers = new int[3];
// Platforms and the stage used in the background.
PShape stage, lPlatform, mPlatform, rPlatform;
// The entire .svg files.
PShape robSVG, battlefieldSVG; 
// The background image used for the Battlefield stage.
PImage bfStage;
// Updated each frame to move the robot towards the mouse.
PVector robLocation = new PVector(200, 260),
        velocity = new PVector(0, 0),
        mouseLocation, dir, acceleration; 
// The top speed the robot can travel toward the mouse.
final int TOP_SPEED = 5;

// Translation Transformation Variables (for translating the platforms)
int pfX = 0,
    pfY = 25,
    pfVelX = 1,
    pfVelY = -1;

// Rotation Transformation Variables (for rotating the robot parts)
int angleOfRotation = 0,
    angleChange = 15;
// The most an angle can rotate to (between 60 and -60).
final int ANGLE_LIMIT = 60;

// Scale Transformation Variables (for scaling the robot arms)
int scaleX = 1,
    scaleY = 1;


// Initializes all of the parts of the robot and parts of the background from svg files.
void setup() {
  size(1020, 825);
  frameRate(30);
  bfStage = loadImage("Battlefield.jpg");
  bfStage.resize(1020, 825);
  image(bfStage, 0, 0);
  createRobot();
  createStage();
}


// Create a robot using the layers from the loaded SVG file.
public void createRobot() {
  PShape eyes, head, neck, body,
       rShoulder, rUpperArm, rLowerArm, rHand,
       lUpperArm, lShoulder, lLowerArm, lHand,
       leg, feet, fire, smoke;
       
  robSVG = loadShape("Robot.svg");
  eyes = robSVG.getChild("Eyes");
  head = robSVG.getChild("Head");
  neck = robSVG.getChild("Neck");
  body = robSVG.getChild("Body");
  rShoulder = robSVG.getChild("R Shoulder");
  rUpperArm = robSVG.getChild("R Upper Arm");
  rLowerArm = robSVG.getChild("R Lower Arm");
  rHand = robSVG.getChild("R Hand");
  lShoulder = robSVG.getChild("L Shoulder");
  lUpperArm = robSVG.getChild("L Upper Arm");
  lLowerArm = robSVG.getChild("L Lower Arm");
  lHand = robSVG.getChild("L Hand");
  leg = robSVG.getChild("Leg");
  feet = robSVG.getChild("Feet");
  fire = robSVG.getChild("Fire");
  smoke = robSVG.getChild("Smoke");
  
  rob = new Robot(eyes, head, neck, body,
                  rShoulder, rUpperArm, rLowerArm, rHand,
                  lShoulder, lUpperArm, lLowerArm, lHand,
                  leg, feet, fire, smoke);
}


// Create the battlefield stage in the background and bush objects.
public void createStage() {
  // The layers included in the Battlefield .svg file.
  PShape pillar, lBush, mBush, rBush,
         lBushFire, mBushFire, rBushFire;
       
  // Retrieving the layers of the Battlefield .svg file.
  battlefieldSVG = loadShape("Battlefield.svg");
  stage = battlefieldSVG.getChild("Stage");
  pillar = battlefieldSVG.getChild("Pillar");
  lPlatform = battlefieldSVG.getChild("L Platform");
  mPlatform = battlefieldSVG.getChild("M Platform");
  rPlatform = battlefieldSVG.getChild("R Platform");
  lBush = battlefieldSVG.getChild("L Bush");
  mBush = battlefieldSVG.getChild("M Bush");
  rBush = battlefieldSVG.getChild("R Bush");
  lBushFire = battlefieldSVG.getChild("L Plant Fire");
  mBushFire = battlefieldSVG.getChild("M Plant Fire");
  rBushFire = battlefieldSVG.getChild("R Plant Fire");
  
  // Parent some objects to the stage.
  stage.addChild(pillar);
  stage.addChild(lBush);
  stage.addChild(mBush);
  stage.addChild(rBush);
  
  // Create the array of bushes.
  bushes[0] = new Bush(lBush, lBushFire, 150, 400, 50, 60, "left");
  bushes[1] = new Bush(mBush, mBushFire, 315, 400, 75, 60, "middle");
  bushes[2] = new Bush(rBush, rBushFire, 565, 400, 65, 60, "right");
}


// Moves the robot towards the mouse using velocity, acceleration, and normalizing.
public void moveRobotTowardMouse() {
  mouseLocation = new PVector(mouseX, mouseY);
  dir = PVector.sub(mouseLocation, robLocation);
  dir.normalize();
  dir.mult(.5);
  acceleration = dir;
  velocity.add(acceleration);
  velocity.limit(TOP_SPEED);
  robLocation.add(velocity);
}


// Does not allow the robot to go off the screen or under the stage.
public void limitMovement() {
  if (robLocation.y > 300) {
    robLocation.y = 300;
  }
  if (robLocation.y < 0) {
    robLocation.y = 0;
  }
  if (robLocation.x < 0) {
    robLocation.x = 0;
  }
  if (robLocation.x > 750) {
    robLocation.x = 750;
  }
}


// Move the platforms in the background.
void movePlatforms() {
  if (pfX < -600 || pfX > 300) {
    pfVelX *= -1;
  }
  if (pfY < -200 || pfY > height / 2) {
    pfVelY *= -1;
  }
  pfX += pfVelX * 5;
  pfY += pfVelY * 10;
  shape(mPlatform, 0, pfY);
  shape(lPlatform, -pfX, 0);
  shape(rPlatform, pfX, 0);
}


// Draw the robot and perform rotations and scaling. If the part has rotated past
// the angle limit, reverse the angle direction and set within limits. Also toggle
// the scaling for the X and Y components of the parts.
public void twerkRobot() {
  pushMatrix();
  translate(robLocation.x, robLocation.y);
  rob.drawTwerkingRobot();
  angleOfRotation += angleChange;
  scaleX = 1;
  
  if (angleOfRotation > ANGLE_LIMIT || angleOfRotation < 0) {
    angleChange = -angleChange;
    angleOfRotation += angleChange;
    scaleY = -scaleY;
    scaleX = 2;
  }
  popMatrix();
}


// Decides when it should start to burn and controls the fire if it does.
public void burningBush() {
  for (int i = 0; i < bushes.length; i++) {
    if (rob.hitBush(bushes[i])) {
      bushes[i].setOnFire();
      bushes[i].setFireTimer(100);
    }
    if (bushes[i].isBurning()) {
      bushes[i].decrementFireTimer();
    }
    if (bushes[i].getFireTimer() <= 0) {
      bushes[i].douseFire();
    }
  }
}


// Create a scene where the background doesn't move.
public void createStaticScene() {
  shape(stage, 0, 50);
  shape(lPlatform, -25, 0);
  shape(mPlatform, 0, 25);
  shape(rPlatform, 25, 0);
  rob.getSmoke().setVisible(false);
  rob.getFire().setVisible(false);
  translate(robLocation.x, robLocation.y);
  rob.drawStaticRobot();
  scaleX = 1;
}

  
// Draws the robot each frame, controls fire timing, and robot movement.
void draw() {
  image(bfStage, 0, 0);
  moveRobotTowardMouse();
  limitMovement();
  
  if (robLocation.y < 300) {
    movePlatforms();
    shape(stage,  0, 50);
    twerkRobot();
    rob.getFire().setVisible(true);
    rob.getSmoke().setVisible(false);
    for (int i = 0; i < bushes.length; i++) {
      if (rob.hitBush(bushes[i])) {
        bushes[i].setOnFire();
        bushes[i].setFireTimer(100);
      }
    }
    if (robLocation.y < 200) {
      rob.getFire().setVisible(false);
      rob.getSmoke().setVisible(true);
    }
  }
  else {
    createStaticScene();
  }
  
  for (int i = 0; i < bushes.length; i++) {
    if (bushes[i].isBurning()) {
      bushes[i].decrementFireTimer();
    }
    if (bushes[i].getFireTimer() <= 0) {
      bushes[i].douseFire();
    }
  }
}
