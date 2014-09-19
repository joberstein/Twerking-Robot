/*
Jesse Oberstein
Computer Graphics
Twerking Robot
*/

// Represents a bush and its hitbox.
public class Bush {
  private PShape bush, bushFire;
  private boolean burning;
  private int x, y, wide, high;
  private String alignment;
  private int fireTimer;
  
  Bush (PShape bush, PShape bushFire, int x, int y, int wide, int high, String alignment) {
    this.bush = bush;
    this.bushFire = bushFire;
    this.burning = false;
    this.x = x;
    this.y = y;
    this.wide = wide;
    this.high = high;
    this.alignment = alignment;
    this.fireTimer = 100;
    
    this.bush.addChild(this.bushFire);
    this.bushFire.setVisible(false);
  }
  
  // Gets the alignment of this bush (left, middle, right).
  public String getAlignment() {
    return this.alignment;
  }
  
  // Gets the time left in the timer for this bush.
  public int getFireTimer() {
    return this.fireTimer;
  }
  
  // Is this bush burning?
  public boolean isBurning() {
    return this.burning;
  }
  
  // Sets this bush's timer with the given time.
  public void setFireTimer(int time) {
    this.fireTimer = time;
  }
  
  // Decrements this bush's timer by 1;
  public void decrementFireTimer() {
    this.fireTimer -= 1;
  }
  
  // Set this bush on fire.
  public void setOnFire() {
    this.bushFire.setVisible(true);
    this.burning = true;
  }
  
  // Put out the fire on this bush.
  public void douseFire() {
    this.fireTimer = 100;
    this.bushFire.setVisible(false);
    this.burning = false;
  }
}
