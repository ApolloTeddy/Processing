//public class Boid
//{
//  private PVector position, velocity, acceleration;
//  private float maxForce, maxSpeed, perception = 35;
//  private int strokeWeight;
  
//  // CORE FUNCTIONS.
//  public Boid( float x, float y )
//  {
//    this.position = new PVector( x, y );
//    velocity = PVector.random2D( );
//    acceleration = new PVector( 0, 0 );
    
//    strokeWeight = 2;
//    maxSpeed = 2;
//    maxForce = 0.03;
//  }
  
//  public void update( )
//  {
//    velocity.add( acceleration );
//    velocity.limit( maxSpeed );
//    position.add( velocity );
//    acceleration.mult( 0 );
//  }
  
//  public void show( )
//  {
//    float theta = velocity.heading2D() + radians(90);
//    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
//    fill(200, 100);
//    stroke(255);
//    pushMatrix();
//    translate(position.x, position.y);
//    rotate(theta);
//    beginShape(TRIANGLES);
//    vertex(0, -strokeWeight*2);
//    vertex(-strokeWeight, strokeWeight*2);
//    vertex(strokeWeight, strokeWeight*2);
//    endShape();
//    popMatrix();
//  }
  
//  public void edges( )
//  {
//    if( position.x > width + strokeWeight )
//      position.x = 0 - strokeWeight;
//    else if( position.x < 0 - strokeWeight)
//      position.x = width + strokeWeight;
//    if( position.y > height + strokeWeight )
//      position.y = 0 - strokeWeight;
//    else if( position.y < 0 - strokeWeight )
//      position.y = height + strokeWeight;
//  }
  
//  private PVector seek( PVector target )
//  {
//    PVector desired = PVector.sub(target, position);
//    desired.setMag( maxSpeed );
    
//    PVector steer = PVector.sub( desired, velocity );
//    steer.limit( maxForce );
//    return steer;
//  }
  
//  // FLOCKING.
//  public void flock( Boid[ ] boids, float[ ] weights )
//  {
//    PVector separation = separationForce( boids );
//    PVector cohesion = cohesionForce( boids );
//    PVector alignment = alignmentForce( boids );
    
//    separation.mult( weights[ 0 ] );
//    cohesion.mult( weights[ 1 ] );
//    alignment.mult( weights[ 2 ] );
    
//    addForce( separation );
//    addForce( separation );
//    addForce( separation );
//  }
  
//  // USEFUL FUNCTIONS.
//  public void setMaxForce( float setMaxForce )
//  {
//    maxForce = setMaxForce;
//  }
  
//  public void addForce( PVector addedForce )
//  {
//    acceleration.add( addedForce );
//  }
  
//  public void updateAndShow( )
//  {
//    update( );
//    edges( );
//    show( );
//  }
  
//  public void setPerception( float newPerception )
//  {
//    perception = newPerception;
//  }
//  // BEHAVIORS.
//  public PVector separationForce( Boid[ ] boids )
//  {
//    PVector steer = new PVector( 0, 0 );
//    int total = 0;
    
//    for( Boid otherBoid : boids )
//    {
//      float dist = PVector.dist( position, otherBoid.position );
//      if( dist > 0 && dist < perception )
//      {
//        PVector diff = PVector.sub( position, otherBoid.position );
//        diff.normalize();
//        diff.div( dist );
//        steer.add( diff );
//        total++;
//      }
//    }
//    if( total > 0 )
//      steer.div( (float)total );
//    if( steer.mag() > 0 )
//    {
//      steer.setMag( maxSpeed );
//      steer.sub( velocity );
//      steer.limit( maxForce );
//    }
//    return steer;
//  }
  
//  public PVector cohesionForce( Boid[ ] boids )
//  {
//    PVector steer = new PVector( 0, 0 );
//    int total = 0;
    
//    for( Boid otherBoid : boids )
//    {
//      float dist = PVector.dist( position, otherBoid.position );
//      if( dist > 0 && dist < perception  )
//      {
//        steer.add( otherBoid.position );
//        total++;
//      }
//    }
//    if( total > 0 )
//    {
//      steer.div( total );
//      return seek( steer );
//    } else
//    {
//      return new PVector( 0, 0 );
//    }
//  }
  
//  public PVector alignmentForce( Boid[ ] boids )
//  {
//    PVector steer = new PVector( 0, 0 );
//    int total = 0;
    
//    for( Boid otherBoid : boids )
//    {
//      float dist = PVector.dist( position, otherBoid.position );
//      if( dist > 0 && dist < perception )
//      {
//        steer.add( otherBoid.velocity );
//        total++;
//      }
//    }
//    if( total > 0 )
//    {
//      steer.div( total );
//      steer.setMag( maxSpeed );
//      PVector heading = PVector.sub( steer, velocity );
//      heading.limit( maxForce );
//      return heading;
//    } else
//    {
//      return new PVector( 0, 0 );
//    }
//  }
//}




// The Boid class

class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    Boid(float x, float y) {
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    position = new PVector(x, y);
    r = 2.0;
    maxspeed = 2;
    maxforce = 0.03;
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(200, 100);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
}
