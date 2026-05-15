/**
 * Slit-Scan from Video Script
 * By Maya Roman, based on a script by Golan Levin
 Requires .mov video file to be in the script's data folder, will select a column in the image and create a slit
 scan image based on the input settings defined
 */

import processing.video.*;
Movie mov;
int videoSliceX;
int drawPositionX;
int framenumber;
int newFrame = 0;
float VidSampleRate;

//**********START VARIABLES TO EDIT***********
String movFile = "cars"; // name of .mov file, must be in the script's data folder
String imgFile = "cars_example"; // name of saved image, will be saved in script's parent folder

boolean customRate = false;
float customSampleRate = 30; // define sample rate, will not be used if custom rate = false and metadata is available

int maxLength = 1000; // max width of video, will be compared to length of video

boolean center = false;
int sliceXpos = 450; // custom position in video, ignored if center = true

char direction = 'R'; // define as left or right, dictates in which direction columns add to form photo

int startDelay = 0; // seconds, time delay to start image later in video
//**********END VARIABLES TO EDIT***********

//----- SETUP FUNCTION ---------------------------------------------------------------------
void setup() {
  size(2, 2); //initialize display window so we can resize it with variables later
  
  // initialize video, stop at the beginning
  mov = new Movie(this, movFile + ".MOV"); 
  mov.play();
  mov.jump(0);
  mov.pause();

  // define sample rate
  if ((customRate == true) || (mov.frameRate == 0)) {
    VidSampleRate = customSampleRate;
    println("Custom sample rate");
  } else {
    VidSampleRate = mov.frameRate;
    println("Metadata frame rate");
  }
  newFrame = getStart();
  println("Sample rate =", VidSampleRate, "FPS");
  println("Total video duration =", mov.duration(), "seconds");

  if (sliceXpos > mov.width) {
    println("ERROR! Slice position is greater than width of video! Choose a number less than", mov.width);
    exit();
  }
  
  // set size of display window based on height and length of video
  int len = getLength();
  int defineW;
  if (len > maxLength) {
    defineW = maxLength; // if video is long, define length
  } else {
    defineW = len; //if video isnt too long, make as long as the video is
  }
  windowResize(defineW, mov.height);
  println("Length =", len, "frames");

  // set position of slice in video
  if (center == true) {
    videoSliceX = mov.width / 2; // position slice in center of video
  } else {
    videoSliceX = sliceXpos; // position slice at custom position
  }

  // define starting position depending on sweep direction
  switch (direction) {
  case 'L':
    drawPositionX = width - 1; // starting position from the right, moving LEFT
    break;
  case 'R':
    drawPositionX = 0; // starting position from the left, moving RIGHT
    break;
  }
  background(0);
}

//----- FUNCTION TO READ THE NEXT FRAME IN THE VIDEO ------------------------------------
void movieEvent(Movie m) {
  m.read();
}

//----- MAIN FUNCTION THAT STEPS THROUGH TIME, ADDING TO THE IMAGE IN THE DISPLAY WINDOW AND SAVES THE IMAGE ------------------------------------
void draw() {
  setFrame(newFrame); // cycle to the next frame in the video

  // Copy a column of pixels from the middle of the video
  // To a location moving slowly across the canvas.

  loadPixels();

  // for loop that moves up the column of one frame
  for (int y = 0; y < mov.height; y++) {
    int setPixelIndex = y*width + drawPositionX;
    int getPixelIndex = y*mov.width  + videoSliceX;
    pixels[setPixelIndex] = mov.pixels[getPixelIndex];
  }
  updatePixels(); //updates the display window with the next column of pixels

  int endCase = 200; // arbitrarily define endCase to prevent error messages
  switch (direction) {
  case 'L':
    drawPositionX--; // shift drawing position over to the LEFT by 1
    endCase = drawPositionX;
    break;
  case 'R':
    drawPositionX++; //shift drawing position over to the RIGHT by 1
    endCase = width - drawPositionX;
    break;
  }

  // Save the image once getting across the display window
  if (endCase < 1) {
    saveFrame(imgFile + ".png");
    exit();
  }

  newFrame++; // update video to next frame
}

//----- FUNCTION TO JUMP TO THE NEXT FRAME IN THE VIDEO ------------------------------------
void setFrame(int n) {
  mov.play();
  float frameDuration = 1.0 / VidSampleRate; // seconds, duration of a single frame
  float where = (n + 0.5) * frameDuration;  // seconds, we move to the middle of the frame by adding 0.5 frames
  float diff = mov.duration() - where;  // Taking into account border effects:

  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }

  mov.jump(where);
  mov.pause();
}

//----- FUNCTION TO GET NUMBER OF FRAMES IN THE VIDEO --------------------------------------
int getLength() {
  return int((mov.duration() - startDelay) * VidSampleRate);   // must be separate in function to resolve variable type conversion issues
}

//----- FUNCTION TO DEFINE THE STARTING FRAME IN VIDEO -------------------------------------
int getStart() {
  return int(startDelay * VidSampleRate);   // must be separate in function to resolve variable type conversion issues
}

//----- COMMENTS FOR DEBUGGING, USEFUL IN THE FOR LOOP IN THE DRAW FUNCTION ----------------
/**
 println("videoSliceX = ",videoSliceX);
 println("drawPositionX = ",drawPositionX);
 println("width = ",width);
 println("height = ",height);
 println("video.width = ",mov.width);
 println("video.height = ",mov.height);
 println("setPixelIndex = ",setPixelIndex);
 println("getPixelIndex = ",getPixelIndex);
 **/
