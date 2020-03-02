color red=color(255,0,0),blue=color(0,0,255);

class Node {
  int x;
  int y;
  int index;
  color c;
  int radius;
  ArrayList<Node> adjN;
  Node(int X, int Y, int i) {
    x=X;
    y=Y;
    index=i;
    radius=15;
    c=blue;
    adjN=new ArrayList<Node>();
  }

  void Plot() {
    stroke(c);
    for (int r=radius; r>0; r--) circle(x, y, r);
    fill(0,0,0);
    textSize(16);
    text(nfs(index,2,0),x-8,y+20);
    for (int i=0; i<adjN.size(); i++) {
      stroke(0, 0, 0);
      line(x, y, adjN.get(i).x, adjN.get(i).y);
      adjN.get(i).Plot();
    }
  }

  int search(int xx, int yy) {
    int ind=-1;
    if(sqrt(pow((xx-x),2)+pow((yy-y),2))<=radius){
      return index;
    }
    for (int i=0; i<adjN.size()&&ind==-1; i++) {
      if ( sqrt(pow((xx-adjN.get(i).x),2)+pow((yy-adjN.get(i).y),2))<=adjN.get(i).radius) {
        return adjN.get(i).index;
      } else {
        ind=adjN.get(i).search(xx, yy);
      }
    }
    return ind;
  }

  void des(int i) {
    if(index==i){
      c=blue;
      return;
    }
    for (int j=0; j<adjN.size(); j++) {
      if (adjN.get(j).index==i) {
        adjN.get(j).c=blue;
        break;
      }
      adjN.get(j).des(i);
    }
  }

  void sel(int i) {
    if (index==i) {
      c=red;
      print("NODE SELECTED\n");
      Selected.add(this);
    }
    for (int j=0; j<adjN.size(); j++) {
      if (adjN.get(j).index==i) {
        adjN.get(j).c=red;
        print("NODE SELECTED\n");
        Selected.add(adjN.get(j));
        break;
      }
      adjN.get(j).sel(i);
    }
  }

  void addAtIndex(int X, int Y, int i) {
    if(index==Selected.get(Selected.size()-1).index){
      print("NODE ADDED\n");
      adjN.add(new Node(X,Y,i));
      select(i);
      i=-1;
    }
    for (int j=0; j<adjN.size()&&i!=-1; j++) {
      if (adjN.get(j).index==Selected.get(Selected.size()-1).index) {
        print("NODE ADDED\n");
        adjN.get(j).adjN.add(new Node(X, Y, i));
        select(i);
        break;
      }
      adjN.get(j).addAtIndex(X, Y, i);
    }
  }

  boolean addNodeOrSel(int X, int Y, int i) {
    int ind=search(X, Y);
    if (ind==-1) {
      addAtIndex(X, Y, i);
      return true;
    } else {
      select(ind);
      return false;
    }
  }
}

void deselect() {
  base.des(Selected.get(0).index);
  Selected.remove(0);
}

void select(int i) {
  for(int j=0;j<Selected.size();j++){
    print(Selected.get(j).index);
    print("\n");
  }
  if (Selected.size()==2) {
    deselect();
  }
  base.sel(i);
}

Node base;
ArrayList<Node>Selected;
int nodeCount;

void setup() {
  frameRate(120);
  size(600, 600);
  nodeCount=0;
  Selected=new ArrayList<Node>();
}

void draw() {
  background(255, 255, 255);
  if (base!=null) {
    base.Plot();
  }
}

void mouseClicked() {
  if (base==null) {
    base=new Node(mouseX, mouseY, nodeCount++);
    print("NODE ADDED\n");
    base.c=red;
    Selected.add(base);
  } else {
    if (base.addNodeOrSel(mouseX, mouseY, nodeCount)) {
      nodeCount++;
    }
  }
}
