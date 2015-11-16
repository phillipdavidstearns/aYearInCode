import wblut.math.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;



void setup() {
  size(100, 100, P3D);
  HE_Mesh mesh = new HE_Mesh(new HEC_Cube().setEdge(100));


  /*
   * A HE_Mesh objects contains 3 kinds of elements, 2 of them self-
   * explanatory:
   *   HE_Vertex
   *   HE_Face
   *   HE_Halfedge, see Halfedge
   * 
   * In the HE_Mesh implementation edges are represented by pairs of halfedges.
   * In each pair of halfedges, one is assigned as the edge. he.isEdge() is true.`
   * Each element has a unique key that is used to access it. 
   */


  // Retrieve a single element; requires the key (a long value normally available from context or a HET_Selector), the key of an element never changes. An element knows its own key:
  long key=0;
  HE_Vertex v= mesh.getVertexByKey(key);
  HE_Face f=  mesh.getFaceByKey(key);
  HE_Halfedge he= mesh.getHalfedgeByKey(key);

  // Or use an index; these are straightforward however the index of an element will typically change. An element does not know its own index, but the mesh it belongs to does:
  int index=0;
  v =mesh.getVertexByIndex(index);
  index=mesh.getIndex(v);
  f= mesh.getFaceByIndex(index);
  he =mesh.getHalfedgeByIndex(index);


  /*
  * Looping through all elements is done with iterators.
   */
  println();
  println("# vertices: "+mesh.getNumberOfVertices());
  HE_VertexIterator vItr=new HE_VertexIterator(mesh);
  while (vItr.hasNext ()) {
    v=vItr.next();
    println(v);
    //do thingy
  }
  println();
  println("# faces: "+mesh.getNumberOfFaces());
  HE_FaceIterator fItr=new HE_FaceIterator(mesh);
  while (fItr.hasNext ()) {
    f=fItr.next();
    println(f);
    //do thingy
  }
  println();
  println("# halfedges: "+mesh.getNumberOfHalfedges());
  HE_HalfedgeIterator heItr=new HE_HalfedgeIterator(mesh);
  while (heItr.hasNext ()) {
    he=heItr.next();
    println(he);
    //do thingy
  }
  println();
  println("# edges: "+mesh.getNumberOfEdges());
  HE_EdgeIterator eItr=new HE_EdgeIterator(mesh);
  while (eItr.hasNext ()) {
    he=eItr.next();
    println(he);
    //do thingy
  }
  println();
  /*
  * Looping around faces and vertices is done with circulators.
   */

  v=mesh.getVertexByIndex(0);
  println("Vertex neighbors of vertex: "+v);
  HE_VertexVertexCirculator vvCrc=new HE_VertexVertexCirculator(v);
  HE_Vertex vneighbor;
  while (vvCrc.hasNext ()) {
    vneighbor=vvCrc.next();
    println(vneighbor);
    //do thingy
  }
  println();

  println("Edge star of vertex: "+v);
  HE_VertexEdgeCirculator veCrc=new HE_VertexEdgeCirculator(v);
  while (veCrc.hasNext ()) {
    he=veCrc.next();
    println(he);
    //do thingy
  }
  println();

  println("Face star of vertex: "+v);
  HE_VertexFaceCirculator vfCrc=new HE_VertexFaceCirculator(v);
  while (vfCrc.hasNext ()) {
    f=vfCrc.next();
    println(f);
    //do thingy
  }
  println();

  println("Outward halfedge star of vertex: "+v);
  HE_VertexHalfedgeOutCirculator vheoCrc=new HE_VertexHalfedgeOutCirculator(v);
  while (vheoCrc.hasNext ()) {
    he=vheoCrc.next();
    println(he);
    //do thingy
  }
  println();

  println("Inward halfedge star of vertex: "+v);
  HE_VertexHalfedgeInCirculator vheiCrc=new HE_VertexHalfedgeInCirculator(v);
  while (vheiCrc.hasNext ()) {
    he=vheiCrc.next();
    println(he);
    //do thingy
  }
  println();
  f=mesh.getFaceByIndex(0);

  println("Vertices of face: "+f);
  HE_FaceVertexCirculator fvCrc=new HE_FaceVertexCirculator(f);
  while (fvCrc.hasNext ()) {
    v=fvCrc.next();
    println(v);
    //do thingy
  }
  println();

  println("Edges of face: "+f);
  HE_FaceEdgeCirculator feCrc=new HE_FaceEdgeCirculator(f);
  while (feCrc.hasNext ()) {
    he=feCrc.next();
    println(he);
    //do thingy
  }
  println();

  HE_Face fadjacent;
  println("Neighboring faces of face: "+f);
  HE_FaceFaceCirculator ffCrc=new HE_FaceFaceCirculator(f);
  while (ffCrc.hasNext ()) {
    fadjacent=ffCrc.next();
    println(fadjacent);
    //do thingy
  }
  println();

  println("Inner halfedges of face: "+f);
  HE_FaceHalfedgeInnerCirculator fheiCrc=new HE_FaceHalfedgeInnerCirculator(f);
  while (fheiCrc.hasNext ()) {
    he=fheiCrc.next();
    println(he);
    //do thingy
  }
  println();

  println("Outer halfedges of face: "+f);
  HE_FaceHalfedgeOuterCirculator fheoCrc=new HE_FaceHalfedgeOuterCirculator(f);
  while (fheoCrc.hasNext ()) {
    he=fheoCrc.next();
    println(he);
    //do thingy
  }
  println();
}

