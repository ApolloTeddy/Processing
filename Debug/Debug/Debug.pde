private int flockSize = 2, driveForce = 5;

private FakeBoid[ ] flock = new FakeBoid[ flockSize ];

void setup( )
{
  fullScreen( );
  background( 153 );
  
  for( int i = 0; i < flockSize; i++ )
  {
    this.flock[ i ] = new FakeBoid( new PVector( random( width ), random( height ) ) );
    this.flock[ i ].setDrivingForce( driveForce );
  }
}

void draw( )
{
  background( 153 );
  
  for( FakeBoid boid : flock )
  {
    boid.separationDisplay( flock, 100, 0.1016 );
    boid.updateAndShow( );
  }  
}
