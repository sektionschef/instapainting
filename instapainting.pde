import http.requests.*; // the http lib

int canvas_side = 640;
int distance = 40;
int offset_random = 20;
int number_vertices = 18; 
PVector[][] vertices = new PVector[number_vertices][number_vertices];

float sxa;
float sya; 
float sxb;
float syb;

color grabbed; //color per triangle

//PImage moritz;
PImage userphoto;     // to hold the incoming image


void setup()
{
    size( canvas_side, canvas_side );
    userphoto = loadImage("example_crop.jpg"); //for the first run
    //getGrams();
    defineVertices(); 
}

void draw()
{

//    background(0);
    noFill();
    noStroke();
    //stroke(255);
    smooth();
    image(userphoto, 0, 0); 
    
    //translate( 30, 30 ); // move out of screen
    
   createTriangles(); 
}


void defineVertices() {
    for (int j = 0; j < number_vertices; j++) {
        for (int i = 0; i < number_vertices; i++) {
            vertices[i][j] = new PVector( i*distance + random(-offset_random, offset_random), j*distance + random(-offset_random, offset_random) );
        }
    }
}


void createTriangles() {
    // calculate middle of triangle first half
    for (int j = 0; j < (number_vertices - 1); j ++) { // -1 because the next j item is always used in the nested loop
        for (int i = 0; i < (number_vertices -1); i++) { // -1 because the last one is not neede anymore
            
            //calculate coordinates of center of triangle
            sxa = (vertices[i][j].x + vertices[i][j+1].x + vertices[i+1][j].x)/3; //sx coordinate of first triangle
            sya = (vertices[i][j].y + vertices[i][j+1].y + vertices[i+1][j].y)/3;
            //point(sxa,sya); //debug

            // limit to canvas size
            sxa = sxa % canvas_side;
            sya = sya % canvas_side;

            
            //grab colour
            loadPixels(); //needed
              grabbed = pixels[int(abs(sxa)) + int(abs(sya)) * width]; //get color at pixel(342,456)
            updatePixels(); //needed
  
            
            //draw the lines
            fill(grabbed);
            beginShape(TRIANGLES);
            //coordinates of triangle for drawing
              vertex( vertices[i][j].x, vertices[i][j].y);
              vertex( vertices[i][j+1].x, vertices[i][j+1].y);
              vertex( vertices[i+1][j].x, vertices[i+1][j].y);
            endShape();
         }
    }
    
    // calculate middle of triangle second half
    for (int j = 0; j < (number_vertices - 1); j ++) { // -1 because the next j item is always used in the nested loop
        for (int i = 0; i < (number_vertices -1); i++) { // -1 because the last one is not neede anymore
            
            //calculate coordinates of center of triangle
            sxb = (vertices[i][j+1].x + vertices[i+1][j].x + vertices[i+1][j+1].x)/3; //sx coordinate of second triangle
            syb = (vertices[i][j+1].y + vertices[i+1][j].y + vertices[i+1][j+1].y)/3;
            //point(sxb,syb); //debug
            

            // limit to canvas size
            sxb = sxb % canvas_side;
            syb = syb % canvas_side;
            
            //grab colour
            loadPixels(); //needed
              grabbed = pixels[int(abs(sxb)) + int(abs(syb)) * width]; //get color at pixel(342,456)
            updatePixels(); //needed
            
            
            //draw the lines
            fill(grabbed);
            beginShape(TRIANGLES); 
            //coordinates of triangle for drawing
              vertex( vertices[i][j+1].x, vertices[i][j+1].y);
              vertex( vertices[i+1][j].x, vertices[i+1][j].y);
              vertex( vertices[i+1][j+1].x, vertices[i+1][j+1].y);
            endShape();
         }
    }
}



void keyPressed()
{
    if (key == '+') {
      defineVertices(); 
    }
}


