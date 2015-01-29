import controlP5.*;

import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.utils.*;
import de.fhpotsdam.unfolding.providers.*;


Table popData;
UnfoldingMap map;
ControlP5 cp5;
int sliderMin = 2011;
int sliderInterval = 1;
int sliderMax = 2014;
float sliderTicks1 = sliderMax;
int year = 2011;
RadioButton r;


void setup() {
  size(800, 600, P2D);
  map = new UnfoldingMap(this, new StamenMapProvider.Toner());
  map.zoomAndPanTo(new Location(54.3333, 10.1333), 11);
  popData = loadTable("popData.csv", "header");
  MapUtils.createDefaultEventDispatcher(this, map);
  //popData.setColumnType("Insgesamt", "int");
  //popData.sort("Insgesamt");
  cp5 = new ControlP5(this);
  // create another slider with tick marks, now without
  // default value, the initial value will be set according to
  // the value of variable sliderTicks2 then.
  cp5.addSlider("sliderTicks1")
    .setPosition(10, 10)
      .setSize(100, 20)
        .setRange(sliderMin, sliderMax)
          .setNumberOfTickMarks((sliderMax-sliderMin) * sliderInterval + 1)
            .snapToTickMarks(true)
              ;

// Radiobutton Control 
  r = cp5.addRadioButton("radioButton")
    .setPosition(10, 40)
      .setSize(40, 20)
        .setColorForeground(color(120))
          .setColorActive(color(255))
            .setColorLabel(color(255))
              .setSpacingColumn(50)
                .addItem("Bevoelkerung", 1)
                  .addItem("Migrationshintergrund", 2)
                    .addItem("Grundsicherung 65+", 3)
                      .addItem("Beschaeftigte", 4)
                        .addItem("Arbeitslose", 5)
                          ;

  for (Toggle t : r.getItems ()) {
    t.captionLabel().setColorBackground(color(0, 80));
    t.captionLabel().style().moveMargin(-7, 0, 0, -3);
    t.captionLabel().style().movePadding(7, 0, 0, 3);
    t.captionLabel().style().backgroundWidth = 120;
    t.captionLabel().style().backgroundHeight = 13;
  }
}
void draw() {
  background(255);

  tint(255, 100);
  map.draw();

  tint(255);

  for (TableRow popRow : popData.rows ()) {
    String districtName = popRow.getString("Stadtteil");
    float lat = popRow.getFloat("Latitude");
    float lng = popRow.getFloat("Longitude");
    int popTotal = popRow.getInt("Einwohner_"+ year +"_Q1");
    int unEmployTotal = popRow.getInt("Arbeitslose_" + year + "_Q1");
    int employTotal = popRow.getInt("Beschaeftigte_"+year+"_Q1");
    int basSec = popRow.getInt("Grundsicherung65+_"+year+"_Q1");
    int migTotal = popRow.getInt("Mighintergrund_"+year+"_Q1");



    Location loc = new Location(lat, lng);
    ScreenPosition pos = map.getScreenPosition(loc);
    float z = map.getZoom()*0.001;

    if (!districtName.equals("KielGesamt")) {
      float texW = textWidth(districtName)/2;

      //Visualizing Total Population
      if (r.getState(0)) {
        float popS = map(popTotal, 0, 240386, 0, 150)*z;
        noStroke();
        rectMode(CORNER);
        fill(255, 0, 0, 180);
        rect(pos.x - texW, pos.y, popS, popS);
      }

      //Visualizing Migration
      if (r.getState(1)) {
        float popM = map((float)migTotal/popTotal, 0, 1, 0, 20)*z;     
        noStroke();
        rectMode(CORNER);
        fill(255, 0, 0, 180);
        rect(pos.x - texW, pos.y, popM, popM);
      }

      //Visualizing Basic Security at old age
      if (r.getState(2)) {
        float popB = map((float)basSec/popTotal, 0, 1, 0, 20)*z;     
        noStroke();
        rectMode(CORNER);
        fill(255, 0, 0, 180);
        rect(pos.x - texW, pos.y, popB, popB);
      }

      //Visualizing Employees
      if (r.getState(3)) {
        float popE = map((float)employTotal/popTotal, 0, 1, 0, 20)*z;     
        println(popE);
        noStroke();
        rectMode(CORNER);
        fill(255, 0, 0, 180);
        rect(pos.x - texW, pos.y, popE, popE);
      }

      //Visualizing Unemployment
      if (r.getState(4)) {
        float popU = map((float)unEmployTotal/popTotal, 0, 1, 0, 20)*z;     
        noStroke();
        rectMode(CORNER);
        fill(255, 0, 0, 180);
        rect(pos.x - texW, pos.y, popU, popU);
      }
      //District Names
      fill(0, 255);
      textAlign(CENTER, BOTTOM);
      text(districtName, pos.x, pos.y);
    }
  }

  // DEBUG show mouse coordinates
  Location location = map.getLocation(mouseX, mouseY);
  textAlign(LEFT, BOTTOM);
  fill(0);
  text(location.toString(), mouseX, mouseY);
}

void sliderTicks1(float val) {
  // handle slider event
  println("Slider event: " + val);
//  cp5.getController("sliderTicks1").getValueLabel()
//    .setText(" " + floor(val) + " Q" + (int) (val * 100 % 100 / 100 * 4 + 1));
  cp5.getController("sliderTicks1").getValueLabel()
    .setText(" " + floor(val) );

    year = (int)val;
    println(year);
    
}

