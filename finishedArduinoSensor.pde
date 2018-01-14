//Author: Daniel Wang
//Objective: Print out 3 graphs, graphing values read/parsed from an arduino sensor as a filled line graph and prints the max values in the 4th quadrant
//Last Update: 7/11/2014
//Version: 71114
import processing.serial.*;
Serial myPort;
String val;
//placeholder used to hold the string read from the port

//Values being read from DT sensor
int humidityValue;
int temperatureValue;
float heatIndexValue = 0; //Combination of heatFirstValue+heatDecimals to form a float
int heatFirstValue; //the integer/non-decimal being read, combined with heatDecimals to form a float due to parsing limiations of the port.
int heatDecimals;
int humidityIndex; //starting index of humidity

//Maximum values of respective values
float maxHeatIndex = 0;
int maxHumidity = 0;
int maxTemp = 0;

//Graph Positions(Used for designating space for each graph, 4 quadrants. Drawing axis' drawing axis'numbers...)

int graphOneAxisY = 470; //the position to draw axis Y numbers for graph 1
int graphOneAxisX = 60; //the position to draw axis X numbers for graph 1
int graphOneNumY = 0; //val to be drawn to create y axis of graph 1 (increments by 5)
int graphOneNumX = 0; //val to be drawn to create x axis of graph 1 (increments by 3)

int graphTwoAxisX = 690; //the position to draw axis X for graph 2
int graphTwoAxisY = 470; //the position to draw axis Y for graph 2  
int graphTwoNumX = 0; //val to be drawn to create x axis of graph 2 (increments by 5)
int graphTwoNumY = 0; //val to be drawn to create y axis of graph 2 (increments by 2)

int graphThreeAxisY = 953; //the position to draw axis Y numbers for graph 3
int graphThreeAxisX = 60; //position to draw axis X numbers for graph 3
int graphThreeNumY = 0; //val to be drawn to create y axis of graph 3 (increments by 10)
int graphThreeNumX = 0; //the val needed to be printed out on the side of the graph (increments by 5)

//Used to draw the filled points for the filled line graph
int graphOneThreeDrawX = 63; //Position for points to be drawn for graph 1 and 3
int graphTwoDrawX = 694; //Position for bar graphs to be drawn in graph 2

//Drawn+Redraw Check
int p = 0; //Check if graph is drawn, graph 1
int q = 0; //Check if graph is drawn, graph 2
int j = 0; //Check if graph is drawn, graph 3

//Timer
int timeActive = 0; //counts how long the program has been active for

//Images 
PImage bg; //Image used in Quadrant 4 as a background


void setup() {
    size(1280, 1024);
    println(Serial.list());
    myPort = new Serial(this, Serial.list()[1], 9600);
    background(255, 255, 255);
    bg = loadImage("cat.jpg"); //loads cat picture
}
void draw() {
    while (myPort.available() > 0) { //if the port is available then do the following
        delay(1000);
        val = myPort.readString(); //read a string from the port
        humidityIndex = val.indexOf("hum") + 4; //gets the index of humidity and adds 4 to get the value 
        humidityValue = Integer.parseInt(val.substring(humidityIndex, humidityIndex + 2)); //parses an int by getting the starting char and ending char using index of
        temperatureValue = Integer.parseInt(val.substring(val.indexOf("Temperature") + 13, val.indexOf("Temperature") + 15)); //parses an int by getting the starting char and ending char using index of
        heatFirstValue = Integer.parseInt(val.substring(val.indexOf("index") + 7, val.indexOf("index") + 9));
        heatDecimals = Integer.parseInt(val.substring(val.indexOf("index") + 10, val.indexOf("index") + 12)); //parses an int by getting the starting char and ending char using index of
        heatIndexValue = heatFirstValue + heatDecimals / 100.00; //calculates the heatIndex because we cannot parse a float or double
        println(val); //prints out our string from the port into the serial monitor
        println("This is your humidity value " + humidityValue + ".00%"); //prints out our values into the serial monitor
        println("This is your Temperature Value " + temperatureValue + ".00 C"); //prints out our values into the serial monitor
        println("This is your heat index value " + heatIndexValue + "*F"); //prints out our values into the serial monitor
    }
    /*used for debugging */
    //   }
    /* this is for debugging the max values for everything...INCREDIBLY ANNOYING 
    println("This is the max humidity value so far " + maxHumidity + ".00%");
    println("This is the max temperature so far " + maxTemp + ".00" + "C");
    println("This is your max heat index so far " + heatIndexValue + "F");
 */
    // while(timeActive <= 540){
    drawCorner(); //does the method drawCorner(); first
    firstGraph(); //does the method firstGraph(); second
    secondGraph(); //does the method secondGraph(); third
    thirdGraph(); //does the method thirdGraph (); fourth
    // timeActive++;
    // }
    delay(10000); //delays the entire process by 10000 so we can properly corolate the time to the graph

}
void firstGraph() {
    if (p == 0) { //used to draw the graph, draws 2 boxes and adds 1 to p so this isnt done agin
        noStroke();
        fill(0, 0, 0);
        rect(60, 50, width / 2 - 75, height / 2 - 100); // draws the black box
        rect(0, height / 2, width, 5); // draws the 4 squares
        rect(width / 2, 0, 5, height); // draws the 4 squares
        fill(255, 255, 255);
        rect(65, 0, width / 2 - 75, (height / 2) - 55); // DRAWS WHITE BOX TO CREATE GRAPH, -5 LEAVES 5 INCHES OF SPACE FOR BLACK.
        fill(0);
        textSize(30);
        text("Humidity Over Time", width / 2 / 2 - 125, 25);
        text("Time In Minutes", width / 2 / 2 - 125, height / 2 - 5);
        p++;
    }

    fill(80);
    pushMatrix(); //pushes a matrix so we can make adjustments such as rotating
    float x = 30;
    float y = 150;
    textAlign(CENTER, BOTTOM);
    textSize(30);
    translate(x, y);
    rotate(-HALF_PI); //we rotate the text by 180 degrees.
    fill(0);
    text("HumidityValue(%)", -85, 0);
    popMatrix();

    while (graphOneAxisY > 35) { //draws the numbers up until a certain position for vertical
        textSize(15);
        text(graphOneNumX, 50, graphOneAxisY); //prints out the according val
        graphOneNumX = graphOneNumX + 3; //how much the val increases after every draw
        graphOneAxisY = graphOneAxisY - 15; // the distance apart from the numbers with each draw
    }

    while (graphOneAxisX < width / 2 - 10) {
        textSize(15);
        text(graphOneNumY, graphOneAxisX, height / 2 - 30);
        graphOneNumY = graphOneNumY + 5;
        graphOneAxisX = graphOneAxisX + 30;
    }

    fill(0);
    textSize(10);
    text("Values <= 25 will print green", width / 2 - 100, 50);
    text("Values >= 26 and <=50 will print blue ", width / 2 - 100, 65);
    text("Values >= 51 and <= 75 will print red", width / 2 - 100, 80);
    text("Values >= 76 will print out black", width / 2 - 100, 95);
    /* Everything below is used to draw the graphs with proper colors according to the value obtained */
    if (humidityValue <= 25) {
        fill(0, 255, 0);
        noStroke(); //no stroke otherwise we'll have black lines due to stroke taking 1 pixel.
        rect(graphOneThreeDrawX, 450 - (humidityValue * 5) + 10, 1, 5 * humidityValue - 3); //draws the rectangle, at position subtracted by the humidityvalue *5 which is calculated by the pixels divided by the rate of increase in numbers so 15/3
        graphOneThreeDrawX++; //increase graphOneThreeDrawX++ so we can move to the next pixel to draw
    }
    if (humidityValue >= 26 && humidityValue <= 50) {
        fill(0, 0, 255);
        noStroke();
        rect(graphOneThreeDrawX, 450 - (humidityValue * 5) + 10, 1, 5 * humidityValue - 3);
        graphOneThreeDrawX++;
    }
    if (humidityValue >= 51 && humidityValue <= 75) {
        fill(255, 0, 0);
        noStroke();
        rect(graphOneThreeDrawX, 450 - (humidityValue * 5) + 10, 1, 5 * humidityValue - 3);
        graphOneThreeDrawX++;
    }
    if (humidityValue >= 76) {
        fill(0);
        noStroke();
        rect(graphOneThreeDrawX, 450 - (humidityValue * 5) + 10, 1, 5 * humidityValue - 3);
        graphOneThreeDrawX++;
    }
}
void secondGraph() { //this is a rehash of the first firstGraph(); goto firstGraph(); for any concerns regarding code
    if (q == 0) {
        noStroke();
        fill(0, 0, 0);
        rect(width / 2 + 50, 50, width / 2 - 75, height / 2 - 100); // draws black box
        fill(255, 255, 255);
        rect(width / 2 + 55, 0, width / 2 - 75, (height / 2) - 55); // DRAWS WHITE BOX TO CREATE GRAPH, -5 LEAVES 5 INCHES OF SPACE FOR BLACK.
        fill(0);
        textSize(30);
        text("Temperature Over Time", width / 2 + width / 2 / 2, 35);
        text("Time In Minutes", width / 2 + width / 2 / 2, height / 2);
        q++;
    }
    pushMatrix();
    float x = 30;
    float y = 150;
    textAlign(CENTER, BOTTOM);
    textSize(30);
    translate(x, y);
    rotate(-HALF_PI);
    fill(0);
    text("Temperature(Celcius)", -90, 646);
    popMatrix();
    while (graphTwoAxisY > 35) {
        fill(0);
        textSize(15);
        text(graphTwoNumY, width / 2 + 40, graphTwoAxisY);
        graphTwoNumY = graphTwoNumY + 2;
        graphTwoAxisY = graphTwoAxisY - 15;
    }
    while (graphTwoAxisX < width - 30) {
        fill(0);
        textSize(15);
        text(graphTwoNumX, graphTwoAxisX, height / 2 - 30);
        graphTwoNumX = graphTwoNumX + 5;
        graphTwoAxisX = graphTwoAxisX + 30;
    }
    fill(0);
    textSize(10);
    text("Values <= 14 will print green", width - 100, 50);
    text("Values >= 15 and <=25 will print blue ", width - 100, 65);
    text("Values >= 26 and <= 49 will print red", width - 100, 80);
    text("Values >= 50 will print out black", width - 100, 95);
    if (temperatureValue <= 14) {
        fill(0, 255, 0);
        noStroke();
        rect(graphTwoDrawX, 450 - (temperatureValue * 7.5) + 10, 1, 7.5 * temperatureValue - 3);
        graphTwoDrawX++;
    }
    if (temperatureValue >= 15 && temperatureValue <= 25) {
        fill(0, 0, 255);
        noStroke();
        rect(graphTwoDrawX, 450 - (temperatureValue * 7.5) + 10, 1, 7.5 * temperatureValue - 3);
        graphTwoDrawX++;
    }
    if (temperatureValue >= 26 && temperatureValue <= 49) {
        fill(255, 0, 0);
        noStroke();
        rect(graphTwoDrawX, 450 - (temperatureValue * 7.5) + 10, 1, 7.5 * temperatureValue - 3);
        graphTwoDrawX++;
    }
    if (temperatureValue >= 50) {
        fill(0);
        noStroke();
        rect(graphTwoDrawX, 450 - (temperatureValue * 7.5) + 10, 1, 7.5 * temperatureValue - 3);
        graphTwoDrawX++;
    }
}
void thirdGraph() { //this is another rehash of firstGraph() go there for any questions
    if (j == 0) {
        noStroke();
        fill(0, 0, 0);
        rect(60, height / 2 + 50, width / 2 - 75, height / 2 - 130);
        fill(255, 255, 255);
        rect(65, height / 2 + 50, width / 2 - 75, height / 2 - 135); // DRAWS WHITE BOX TO CREATE GRAPH, -5 LEAVES 5 INCHES OF SPACE FOR BLACK.
        fill(0);
        textSize(30);
        text("Heat Index Over Time", width / 2 / 2, height / 2 + 45);
        text("Time In Minutes", width / 2 / 2, height - 25);
        j++;
    }
    fill(80);
    pushMatrix();
    float x = 30;
    float y = 150;
    textAlign(CENTER, BOTTOM);
    textSize(30);
    translate(x, y);
    rotate(-HALF_PI);
    fill(0);
    text("HumidityValue(Fahrenheit)", -600, 0);
    popMatrix();
    while (graphThreeAxisY > height / 2 + 55) {
        fill(0);
        textSize(15);
        text(graphThreeNumY, 45, graphThreeAxisY);
        graphThreeNumY = graphThreeNumY + 10;
        graphThreeAxisY = graphThreeAxisY - 15;
    }
    while (graphThreeAxisX < width / 2 - 15) {
        textSize(15);
        text(graphThreeNumX, graphThreeAxisX, height - 62);
        graphThreeNumX = graphThreeNumX + 5;
        graphThreeAxisX = graphThreeAxisX + 30;
    }
    fill(0);
    textSize(10);
    text("Values <= 50 will print green", width / 2 - 100, height / 2 + 50);
    text("Values >= 51 and <=76 will print blue ", width / 2 - 100, height / 2 + 65);
    text("Values >= 77 and <= 100 will print red", width / 2 - 100, height / 2 + 80);
    text("Values >= 101 will print out black", width / 2 - 100, height / 2 + 95);
    if (heatIndexValue <= 50) {
        fill(0, 255, 0);
        noStroke();
        rect(graphOneThreeDrawX, 943 - (heatIndexValue * 1.5), 1, 1.5 * heatIndexValue - 4);

    }
    if (heatIndexValue >= 51 && heatIndexValue <= 76) {
        fill(0, 0, 255);
        noStroke();
        rect(graphOneThreeDrawX, 943 - (heatIndexValue * 1.5), 1, 1.5 * heatIndexValue - 4);

    }
    if (heatIndexValue >= 77 && heatIndexValue <= 100) {
        fill(255, 0, 0);
        noStroke();
        rect(graphOneThreeDrawX, 943 - (heatIndexValue * 1.5), 1, 1.5 * heatIndexValue - 4);

    }
    if (heatIndexValue >= 101) {
        fill(0);
        noStroke();
        rect(graphOneThreeDrawX, 943 - (heatIndexValue * 1.5), 1, 1.5 * heatIndexValue - 4);

    }
}
void drawCorner() { //this draws bottom right corner box
    image(bg, width / 2, height / 2); //we draw our background image the cat
    if (humidityValue > maxHumidity) { // checks if humidityValue is currently greater then current maxHumidity 
        maxHumidity = humidityValue; //if greater set maxHumidity to humidityValue
    }
    if (temperatureValue > maxTemp) { // checks if temperatureValue is greater than current maxTemp
        maxTemp = temperatureValue; //if greater assign maxTemp the value of temperatureValue
    }
    if (heatIndexValue > maxHeatIndex) { //checks if the heatIndexValue is greater than our current maxHeatIndex
        maxHeatIndex = heatIndexValue; //if true it assigns maxHeatIndex the value of heatIndexValue
    }
    fill(255); //colors everything with 255, white
    textSize(30); //text size is set to 30
    text("Current Stats", width / 2 + 200, height / 2 + 50); //writes the words Current Stats at the following position
    rect(width / 2 + 50, height / 2 + 60, 300, 5); // draws an underline for current stats
    textSize(15); //changes textsize to 15
    /* Writes out the following information into the bottom right corner */
    text("Your Maximum Humidity Value up till now is " + maxHumidity + ".00%", width / 2 + 200, height / 2 + 100);
    text("Your Max Temperature Value up till now is " + maxTemp + ".00 C", width / 2 + 200, height / 2 + 140);
    text("Your Max Heat Index up till now is " + maxHeatIndex + "*F", width / 2 + 200, height / 2 + 180);
    text("Your current humidity " + humidityValue + ".00%", width / 2 + 200, height / 2 + 220);
    text("Your current heat index " + heatIndexValue + "*F", width / 2 + 200, height / 2 + 260);
    text("Your current temperature " + temperatureValue + ".00 C", width / 2 + 200, height / 2 + 300);
    text("This is a program developed by Daniel Wang", width - 200, height - 20);
}