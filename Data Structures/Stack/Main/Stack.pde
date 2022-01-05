class Stack<t> {
  private class Node {
    t data;
    Node next;

    Node(t data) {
      this.data = data;
    }
  }

  Node top;

  boolean isEmpty() {
    return top == null;
  }
  t peek() {
    return top.data;
  }
  void push(t data) {
    Node newTop = new Node(data);
    newTop.next = top;
    top = newTop;
  }
  t pop() {
    if (isEmpty()) {
      return null;
    }
    t out = peek();
    if (top.next != null) {
      top = top.next;
    } else {
      top = null;
    }
    return out;
  }
  int size() {
    if(isEmpty()) return 0;
    int total = 1;
    Node current = top;
    while(current.next != null) {
      current = current.next;
      total++;
    }
    return total;
  }
}
