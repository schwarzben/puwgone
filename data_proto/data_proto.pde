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
int sliderMin = 2008;
int sliderInterval = 4;
int sliderMax = 2014;
float sliderTicks1 = sliderMax;

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
      .setSize(100, 10)
        .setRange(sliderMin, sliderMax)
          .setNumberOfTickMarks((sliderMax-sliderMin) * sliderInterval + 1)
            .snapToTickMarks(true)
              ;
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
    int popTotal = popRow.getInt("Einwohner_2014_Q1");
    Location loc = new Location(lat, lng);
    ScreenPosition pos = map.getScreenPosition(loc);
    if (!districtName.equals("KielGesamt")) {
      textAlign(CENTER, BOTTOM);
      text(districtName, pos.x, pos.y);

      //popRect
      float popS = map(popTotal, 0, 240386, 0, 170);
      noStroke();   
      fill(255, 0, 0, 180);
      rect(pos.x, pos.y, popS, popS);
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
  cp5.getController("sliderTicks1").getValueLabel()
    .setText("" + floor(val) + " Q" + (int) (val * 100 % 100 / 100 * 4 + 1));
}

