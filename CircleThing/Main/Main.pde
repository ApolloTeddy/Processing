ArrayList<Circle> listOfCircles = new ArrayList<Circle>(); // ArrayLists hold a dynamic quantity of data, in our case, Circles. :)
int numberOfCircles = 10; // How many circles do we want?
int minRadius = 25, maxRadius = 150; // Minimum, and Maximum radii for our circles.

void setup() // The setup method is called before the first frame update.
{ 
  size(700, 600); // The size of the window.
  background(175, 9 , 148); // set the background color in draw.
  
  for(int i = 0; i < numberOfCircles; i++) // Five times, add a circle with a random position, and a random radius within the range specified.
    listOfCircles.add(new Circle(random(width), random(height), int(random(minRadius, maxRadius + 1))));
    
  listOfCircles.forEach(c -> c.show()); // ForEach loop with a Lambda expression, for every circle in our list of circles, show the circle.
}
