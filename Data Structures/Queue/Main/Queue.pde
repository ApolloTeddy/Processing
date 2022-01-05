class Queue<t> {
  class Node {
    t data;
    Node next;

    Node(t data) {
      this.data = data;
    }
  }
  Node head, tail;

  boolean isEmpty() {
    return head == null;
  }

  t peek() {
    if (isEmpty()) {
      return null;
    }
    return tail.data;
  }

  void enqueue(t data) {
    Node newNode = new Node(data);
    if (tail != null) {
      tail.next = newNode;
    }
    tail = newNode;
    if (head == null) {
      head = newNode;
    }
  }

  t dequeue() {
    t data = head.data;
    if (head != null) {
      head = head.next;
    } else {
      tail = null;
    }
    return data;
  }
}
