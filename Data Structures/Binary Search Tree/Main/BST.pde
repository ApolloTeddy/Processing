class Node {
  Node left, right;
  int data;
  Node(int data) {
    this.data = data;
  }
  
  void insert(int val) {
    if(val <= this.data) {
      if(left == null) {
        left = new Node(val);
      } else {
        left.insert(val);
      }
    } else {
      if(right == null) {
        right = new Node(val);
      } else {
        right.insert(val);
      }
    }
  }
  
  boolean contains(int val) {
    if(val == this.data) {
      return true;
    } else if(val < this.data) {
      if(left == null) {
        return false;
      } else {
        return left.contains(val);
      }
    } else {
      if(right == null) {
        return false;
      } else {
        return right.contains(val);
      }
    }
  }
  
  void printOut() {
    if(this.left != null) {
      this.left.printOut();
    }
    print(this.data + " ");
    if(this.right != null) {
      this.right.printOut();
    }
  }
}
