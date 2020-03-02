class Node{
    public int index;
    public int x;
    public int y;
    public int r;
    public int g;
    public int b;
    public int radius;
    public boolean selected;
    Node(int X,int Y,int i){
      index=i;
      x=X;
      y=Y;
      r=255;
      g=0;
      b=0;
      radius=15;
      selected= true;
    }
    boolean compDist(int X,int Y){
      return sqrt((x-X)^2+(y-Y)^2)<=radius/5?true:false;
    }
    void plot(){
      stroke(r,g,b);
      for(int i=radius;i>0;i--){
        circle(x,y,i);
      }
    }
    void updatePos(int X,int Y){
      x=X;
      y=Y;
    }
    void select(){
      selected=true;
      r=255;
      b=0;
    }
    void deselect(){
      selected=false;
      r=0;
      b=255;
    }
}

class graph{
  ArrayList<Node> nodes;
  ArrayList<Node> selected;
  graph(){
    nodes=new ArrayList<Node>();
    selected=new ArrayList<Node>();
  }
  void plotGraph(){
    for(int i=0;i<nodes.size();i++){
      nodes.get(i).plot();
    }
    plotEdges();
  }
  
  void plotEdges(){
    for(int i=0;i<nodes.size()-1;i++){
      stroke(0,0,0);
      line(nodes.get(i).x,nodes.get(i).y,nodes.get(i+1).x,nodes.get(i+1).y);
    }
  }
  
  void addNode(int X,int Y){
    boolean selectionFlag=false;
    for(int i=0;i<nodes.size()&&selectionFlag==false;i++){
      if(nodes.get(i).compDist(X,Y)&&selected.get(0).index!=nodes.get(i).index&&selected.get(1).index!=nodes.get(i).index){
        nodes.get(i).select();
        selected.add(nodes.get(i));
        selectionFlag=true;
      }
    }
    if(!selectionFlag){
      nodes.add(new Node(X,Y,nodes.size()));
      selected.add(nodes.get(nodes.size()-1));
    }
    if(selected.size()==3){
      nodes.get(selected.get(0).index).deselect();
      selected.remove(0);
    }
  }
}

graph G;

void setup(){
  size(400,400);
  G=new graph();
}

void draw(){
  background(255,255,255);
  G.plotGraph();
}

void mouseClicked(){
  G.addNode(mouseX,mouseY);
  print(G.selected.size());
}
