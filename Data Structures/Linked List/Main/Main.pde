LinkedList<Integer> clicks; // Our linked list, currently of type integer

int left = 0, right = 0, middle = 0; // Variables to keep count of the amount of times we've clicked our mouse.

void setup() {
  size(200, 200);
  clicks = new LinkedList<Integer>(); // Instantiate our linked list.
  clicks.append(0); // Initialize our list with a value of 0.
}

void draw() {
  print("\n\n\n" + middle + "\n"); // Print out the current number we are removing from the list
  if(clicks.head != null) printList(clicks); // If our list isnt null, print it out!
}

void mousePressed() {
  if(left >= 10) left = 0; // If our left clicks are larger than 10, set them to 0.
  if(right >= 10) right = 0; // If our right clicks are larger than 10, set them to 0.
  if(middle >= 10) middle = 0; // If our middle clicks are larger than 10, set them to 0.
  if(mouseButton == LEFT) {
    left++;
    clicks.prepend(left); // add the amount of left clicks to the front of the list
  }
  if(mouseButton == RIGHT) {
    right++;
    clicks.append(right); // add the amount of right clicks to the back of the list
  }
  if(mouseButton == CENTER) {
    middle++;
    clicks.remove(middle); // remove the value of the number of middle clicks from the first instance in the list.
  }
}

void printList(LinkedList list) { // Print out the data in our list.
  Node current = list.head;
  while(true) {
    print(current.data + " ");
    if(current.next != null)
      current = current.next;
    else
      break;
  }
}
