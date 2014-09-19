/*
Jesse Oberstein
Computer Graphics
Twerking Robot
*/

// Represents a robot as all of it's parts.
public class Robot {
  private PShape eyes, head, neck, body,
                 rShoulder, rUpperArm, rLowerArm, rHand,
                 lUpperArm, lShoulder, lLowerArm, lHand,
                 leg, feet, fire, smoke;

  Robot(PShape eyes, PShape head, PShape neck, PShape body, 
        PShape rShoulder, PShape rUpperArm, PShape rLowerArm, PShape rHand, 
        PShape lShoulder, PShape lUpperArm, PShape lLowerArm, PShape lHand, 
        PShape leg, PShape feet, PShape fire, PShape smoke) {
    this.eyes = eyes;
    this.head = head;
    this.neck = neck;
    this.body = body;
    this.rShoulder = rShoulder;
    this.rUpperArm = rUpperArm;
    this.rLowerArm = rLowerArm;
    this.rHand = rHand;
    this.lShoulder = lShoulder;
    this.lUpperArm = lUpperArm;
    this.lLowerArm = lLowerArm;
    this.lHand = lHand;
    this.leg = leg;
    this.feet = feet;
    this.fire = fire;
    this.smoke = smoke;
    
    this.head.addChild(this.eyes);
    this.body.addChild(this.lShoulder);
    this.body.addChild(this.rShoulder);
    this.feet.addChild(this.fire);
    this.feet.addChild(this.smoke);
    this.fire.setVisible(false);
    this.smoke.setVisible(false);
  }
  
  // Gets the fire from this robot.
  public PShape getFire() {
    return this.fire;
  }
  
  // Gets the smoke from this robot.
  public PShape getSmoke() {
    return this.smoke;
  }
  
  // Draws this robot without rotations or scaling.
  public void drawStaticRobot() {
      noTint();
      this.eyes.enableStyle();
      shape(robSVG, 0, 0);
  }
  
  // Draws the rotating body and shoulders of this robot.
  public void drawBody() {
    pushMatrix();
    translate(124, 111);
    rotate(radians(angleOfRotation / 4));
    shape(this.body, -124, -111);
    popMatrix();
  }
  
  // Draws the red eyes of this robot.
  public void drawLaserEyes() {
    this.eyes.disableStyle();
    pushMatrix();
    translate(124, 93);
    rotate(radians(-angleOfRotation + 30));
    shape(this.eyes, -124, -93);
    popMatrix();
    fill(255, 0, 0);
    tint(255, 100, 150);
  }
  
  // Draws the rotating head of this robot.
  public void drawHead() {
    pushMatrix();
    translate(124, 103);
    rotate(radians(-angleOfRotation + 30));
    shape(this.head, -124, -103);
    popMatrix();
  }
  
  // Draws the rotating neck of this robot.
  public void drawNeck() {
    pushMatrix();
    translate(124, 120);
    rotate(radians(-angleOfRotation + 30));
    shape(this.neck, -124, -120);
    popMatrix();
  }
  
  // Draws the rotating and scaling right upper arm of this robot.
  public void drawRightArm() {
    pushMatrix();
    translate(170, 130);
    rotate(radians(-angleOfRotation));
    scale(scaleX, scaleY);
    shape(this.rUpperArm, -170, -130);
    shape(this.rLowerArm, -170, -130);
    shape(this.rHand, -170, -130);
    popMatrix();
  }
  
  // Draws the rotating and scaling left upper arm of this robot.
  public void drawLeftArm() {
    pushMatrix();
    translate(78, 130);
    rotate(radians(angleOfRotation));
    scale(scaleX, scaleY);
    shape(this.lUpperArm, -78, -130);
    shape(this.lLowerArm, -78, -130);
    shape(this.lHand, -78, -130);
    popMatrix();
  }

  // Draws the rotating leg of this robot.
  public void drawLeg() {
    pushMatrix();
    translate(124, 139);
    rotate(radians(angleOfRotation - 15));
    shape(this.leg, -124, -139);
    popMatrix();
  }
  
  // Draws rotating feet of this robot.
  public void drawFeet() {
    pushMatrix();
    translate(124, 179);
    rotate(radians(angleOfRotation / 2));
    shape(this.feet, -124, -179);
    popMatrix();
  }
   
  // Draws this robot with various moving parts and tints 
  // the screen pink if the robot is in the air.
  public void drawTwerkingRobot() {
    if (robLocation.y < 300) {       
      drawLaserEyes();
      drawNeck();
      drawHead();
      drawLaserEyes();
      drawRightArm();
      drawLeftArm();
      drawLeg();
      drawBody();
      drawFeet();
    }
  }
  
  // Does this robot hit a given bush?
  public boolean hitBush(Bush bush) {
    return robLocation.y + robSVG.height > bush.y 
      && robLocation.y + robSVG.height < bush.y + bush.high 
      && robLocation.x + robSVG.width/2 > bush.x 
      && robLocation.x + robSVG.width/2 < bush.x + bush.wide;
  }
}

