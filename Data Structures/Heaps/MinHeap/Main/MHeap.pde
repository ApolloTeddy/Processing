class MHeap {
  int capacity = 10;
  int size = 0;
  
  int[] items = new int[capacity];
  
  int gLI(int pInd) { return 2 * pInd + 1; }
  int gRI(int pInd) { return 2 * pInd + 2; }
  int gPI(int cInd) { return (cInd - 1) / 2; }
  
  boolean hLC(int ind) { return gLI(ind) < size; }
  boolean hRC(int ind) { return gRI(ind) < size; }
  boolean hP(int ind) { return gPI(ind) >= 0; }
  
  int lC(int ind) { return items[gLI(ind)]; }
  int rC(int ind) { return items[gRI(ind)]; }
  int p(int ind) { return items[gPI(ind)]; }
  
  void swap(int indA, int indB) {
    int tmp = items[indA];
    items[indA] = items[indB];
    items[indB] = tmp;
  }
  
  void ensureExtraCapacity() {
    if(size == capacity) {
      items = copyOf(items, capacity);
      capacity *= 2;
    }
  }
  
  int[] copyOf(int[] items, int capacity) {
    int[] output = new int[capacity * 2];
    int current = 0;
    for(int i : items) {
      output[current] = i;
    }
    return output;
  }
  
  int peek() {
    if(size == 0) throw new IllegalStateException();
    int item = items[0];
    items[0] = items[size - 1];
    size--;
    heapifyDown();
    return item;
  }
  
  void add(int item) {
    ensureExtraCapacity();
    items[size] = item;
    size++;
    heapifyUp();
  }
  
  void heapifyUp() {
    int index = size - 1;
    while(hP(index) && p(index) > items[index]) {
      swap(gPI(index), index);
      index = gPI(index); 
    }
  }
  
  void heapifyDown() {
    int index = 0;
    while(hLC(index)) {
      int sCI = gLI(index);
      if(hRC(index) && rC(index) < lC(index)) {
        sCI = gRI(index);
      }
      if(items[index] < items[sCI]) {
        break;
      } else {
        swap(index, sCI);
      }
      index = sCI;
    }
  }
}
