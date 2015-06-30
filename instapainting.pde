import http.requests.*; // the http lib

int canvas_side = 640;
int distance = 40; //distance between vertices
int offset_random = 20; //random distor variable, offset for vertices
int number_vertices = 18; //size of the grid
PVector[][] vertices = new PVector[number_vertices][number_vertices];

//get the API call together
String API_url;
String API_url_1;
String Hashtag;       // for the search
String API_url_2;
String clientId;      // instagram client_id for authentication

//coordinates for the middle or the traingles
float sxa;
float sya; 
float sxb;
float syb;

color grabbed; //color grabbed per triangle

PImage userphoto;     // to hold the incoming image

void setup()
{
  //define the API call
  API_url_1 = "https://api.instagram.com/v1/tags/";
  Hashtag = "selfie";                                //without #
  API_url_2 = "/media/recent?count=2&client_id="; 
  clientId = loadStrings("client_id.txt")[0];
  API_url = API_url_1 + Hashtag + API_url_2 + clientId;
  //println(API_url);     //debug
  
  size( canvas_side, canvas_side );


  noFill();
  noStroke();
  smooth();
  userphoto = loadImage("example_crop.jpg"); //for the first run
  image(userphoto, 0, 0);
  getGrams(); //get instagram images
  defineVertices(); //define the vertices
  createTriangles(); //create triangles with random coordinates
}

void draw()
{

//    background(0);
  
  if (frameCount % 1000 == 0) { 
    println("Getting grams...");
    getGrams();
  }
 
    
    //translate( 30, 30 ); // move out of screen
    
  if (frameCount % 300 == 0) {
    if (userphoto != null) {
      println("userphoto available");
      image(userphoto, 0, 0, 640, 640); //load userphoto
    } else {
      println("userphoto null");
    }
    println("Define Vertices");
    defineVertices(); 
    println("Change Triangles...");
    createTriangles();
  }


}


void getGrams() {
  GetRequest get = new GetRequest(API_url);
  get.send(); // program will wait until the request is completed
 
    // now we need to deal with the data.
  // First, we convert it to an "internal" JSON object
  JSONObject content = parseJSONObject(get.getContent()); 
 
  // Next, we get from that an array of all the posts in the returned data object
  JSONArray data = content.getJSONArray("data"); 
 
  // Let's get the first chunk of that data into another object called first
  JSONObject first = data.getJSONObject(0); 
  //println(first);  //print last photo

  // To test, let's get out the filter from that chunk, because that's a string not an object
  //String filter = first.getString("filter");
 
  // Let's find the images object in the first chunk of data
  JSONObject images = first.getJSONObject("images");
  // and let's get the standard_resolution version of the image in the images object
  JSONObject standard_resolution = images.getJSONObject("standard_resolution");
  // finally, let's get the string with the URL in it
  String URL = standard_resolution.getString("url");
  // Print it to the console, open champagne etc
  println("URL = " + URL);
  
  JSONObject user = first.getJSONObject("user");
  String usernameString = user.getString("username");
  println("Username = " + usernameString);
 
  // Load in the image at that URL
  userphoto = loadImage(URL);
}



void defineVertices() {
    for (int j = 0; j < number_vertices; j++) { //rows
        for (int i = 0; i < number_vertices; i++) { //columns
            vertices[i][j] = new PVector( i*distance + random(-offset_random, offset_random), j*distance + random(-offset_random, offset_random) ); //position with random distortion coefficient
        }
    }
}


void createTriangles() {
    // calculate middle of triangle first half - 2 points first row, 1 point second row
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
            loadPixels(); //needed for this method
              grabbed = pixels[int(abs(sxa)) + int(abs(sya)) * width]; //get color at pixel(342,456)
            updatePixels(); //needed
  
            
            chooseColor(); //fill with grabbed color or with transparency
            
            //draw the lines
            beginShape(TRIANGLES); //draw triangles out of vertices
            //coordinates of triangle for drawing
              vertex( vertices[i][j].x, vertices[i][j].y);
              vertex( vertices[i][j+1].x, vertices[i][j+1].y);
              vertex( vertices[i+1][j].x, vertices[i+1][j].y);
            endShape();
         }
    }
    
    // calculate middle of triangle second half - 1 point first row, 2 points second row
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
            
            chooseColor();//fill with grabbed color or with transparency

            //draw the lines
            beginShape(TRIANGLES); 
            //coordinates of triangle for drawing
              vertex( vertices[i][j+1].x, vertices[i][j+1].y);
              vertex( vertices[i+1][j].x, vertices[i+1][j].y);
              vertex( vertices[i+1][j+1].x, vertices[i+1][j+1].y);
            endShape();
         }
    }
}


void chooseColor() {
  if (int(random(0,9)) == 5) {
    fill(0,0,0,0); //fill with transparency
  } else {
    fill(grabbed); //fill with grabbed colour
  }
}

void keyPressed()
{
    if (key == '+') {
      println("Key Pressed! - Define Vertices");
      defineVertices();
      println("Key Pressed! - Change Triangles...");
      createTriangles();
    }
}


