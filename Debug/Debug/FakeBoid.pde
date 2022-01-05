public class FakeBoid
{
  private PVector position, velocity, acceleration;
  private float drivingForce = 1, maxSpeed = 5;
  private boolean isOver = false;
  public color vectorRenderColor = #4B37D8; // #F25F64 for selected color.
  public int strokeWeight = 15, stroke = 15, scale = 25000000;
  
  public FakeBoid( PVector position )
  {
    this.position = position;
    this.velocity = new PVector( );
    this.acceleration = new PVector( );
  }
  
  public void updateAndShow( )
  {
    update( );
    show( );
  }
  
  public void update( )
  {
    this.velocity.add( this.acceleration );
    this.velocity.limit( this.maxSpeed );
    this.acceleration.mult( 0 );
  }
  
  public void show( )
  {
    if( mouseX > this.position.x - this.strokeWeight && mouseX < this.position.x + this.strokeWeight && mouseY > this.position.y - this.strokeWeight && mouseY < this.position.y + this.strokeWeight )
    {
        this.stroke = 100;
        this.isOver = true;
        
        if( mousePressed && this.isOver )
        {
          this.position.x = mouseX;
          this.position.y = mouseY;
        }
    }
    else
    {
        this.stroke = 15;
        this.isOver = false;
    }
      
    strokeWeight( strokeWeight );
    stroke( stroke );
    point( this.position.x, this.position.y );
    color( vectorRenderColor );
    line( this.position.x, this.position.y, this.position.x + this.acceleration.x * scale, this.position.y + this.acceleration.y * scale );
  }
  
  public void separationDisplay( FakeBoid[ ] boids, float perception, float strength )
  {
    int total = 0;
    PVector steering = new PVector( );
    
    for ( FakeBoid otherBoid : boids )
    {
      var dist = PVector.dist( this.position, otherBoid.position );
      if ( otherBoid != this && dist < perception )
      {
        var diff = PVector.sub( this.position, otherBoid.position );
        diff.div( dist * dist );
        steering.add( diff );
        total++;
      }
    }
    
    if ( total > 0 )
    {
      steering.div( total );
      steering.setMag( this.drivingForce );
      steering.sub( this.velocity );
      steering.limit( this.maxSpeed );
    }
    
    System.out.println( steering.mult( strength ) ) ;
    this.acceleration.add( steering.mult( strength ) );
  }
  
  public void setDrivingForce( float driveForce )
  {
    this.drivingForce = driveForce;
  }
}
