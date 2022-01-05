//private int flockSize = 120, driveForce = 5;

//private Boid[ ] flock = new Boid[ flockSize ];

//void setup( )
//{
//  fullScreen( );
//  background( 153 );
//  for( int i = 0; i < flockSize; i++ )
//  {
//    flock[ i ] = new Boid( random( width ), random(  height ) );
//    flock[ i ].setMaxForce( driveForce );
//  }
//}

//void draw( )
//{
//  background( 153 );
//  for( Boid boid : flock )
//  {
//    boid.flock( flock, new float[ ] { 1.5, 1f, 1f } );
//    boid.updateAndShow( );
//  }
//}




/**
 * Flocking 
 * by Daniel Shiffman.  
 * 
 * An implementation of Craig Reynold's Boids program to simulate
 * the flocking behavior of birds. Each boid steers itself based on 
 * rules of avoidance, alignment, and coherence.
 * 
 * Click the mouse to add a new boid.
 */

Flock flock;

void setup() {
  size(640, 360);
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
}

void draw() {
  background(50);
  flock.run();
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}
