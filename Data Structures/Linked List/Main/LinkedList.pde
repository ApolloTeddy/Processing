class LinkedList<T> { // Linked List class to store our current head pointer, and provide methods to append, prepend, and remove values from the list.
  Node<T> head; // Head pointer.
  
  void append(T data) { // Append data to the end of the list.
    if(this.head == null) { // If our list is empty, create our list!
      this.head = new Node(data); // this basically works as a constructor, but i don't have to write it
      return;
    }
    Node<T> current = this.head;
    while(current.next != null) { // While the next node isn't empty,
      current = current.next; // our current node is equal to the next.
    } // At the end of our list,
    current.next = new Node(data); // append our data!
  }
  
  void prepend(T data) { // Add data to the front of our list
    if(this.head == null) { // If our list is empty, create our list!
      this.head = new Node(data); // this basically works as a constructor, but i don't have to write it
      return;
    }
    Node<T> newHead = new Node(data); // New head variable.
    newHead.next = this.head; // Set the new head's next pointer to our lists' head.
    this.head = newHead; // Set the lists head to our new head!
  }
  
  void remove(T data) { // Delete the first found value from our linked list!
    if(this.head == null) return; // If our head is null, don't delete anything, you can't!
    if(this.head.data == data || this.head.data.equals(data)) { // If our heads' data is equal to the data we want to remove,
      this.head = this.head.next; // Our lists' head is equal to the next value in the list.
      return;
    }
    
    Node<T> current = this.head;
    while(current.next != null) { // Loop through every data in our list until we reach the end, or the data we want to remove:
      if(current.next.data == data || current.next.data.equals(data)) { // if the data is equal to the data we want to remove:
        current.next = current.next.next; // the datas' pointer is removed from the list, effectively deleting it.
        return;
      }
      current = current.next;
    }
  }
}

class Node<T> { // Data type that holds a pointer to the next data in the linked list.
  Node<T> next; // Next data pointer.
  T data; // Current data value.
  
  Node(T data) { // Constructor
    this.data = data;
  }
}
