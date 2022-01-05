class Queue<T>
{
  int capacity;
  ArrayList<T> elements;
  
  Queue(int capacity)
  {
    this.capacity = capacity;
    this.elements = new ArrayList<T>();
  }
  
  public void enqueue(T t)
  {
    if(this.elements.size() < this.capacity)
    {
      this.elements.add(t);
    } 
    else
    {
      this.dequeue();
      this.elements.add(t);
    }
  }
  
  public void dequeue()
  {
    if(this.elements.size() != 0)
    {
      this.elements.remove(this.elements.size() - 1);
    }
  }
  
  public int size()
  {
    return this.elements.size();
  }
  
  public T get(int index)
  {
    return this.elements.get(index);
  }
  
  public void set(int index, T t)
  {
    this.elements.set(index, t);
  }
}
