<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.2" tiledversion="1.2.4" name="thin_walls" tilewidth="64" tileheight="64" tilecount="4" columns="0">
 <grid orientation="orthogonal" width="1" height="1"/>
 <properties>
  <property name="thin_wall" type="bool" value="true"/>
 </properties>
 <tile id="0">
  <image width="64" height="64" source="thin_walls/wall24_horizontal.png"/>
 </tile>
 <tile id="1">
  <image width="64" height="64" source="thin_walls/wall24_vertical.png"/>
 </tile>
 <tile id="2">
  <properties>
   <property name="scale" type="float" value="0.5"/>
   <property name="transparent" type="bool" value="true"/>
  </properties>
  <image width="64" height="64" source="thin_walls/wall35_horizontal.png"/>
 </tile>
 <tile id="3">
  <properties>
   <property name="scale" type="float" value="0.5"/>
   <property name="transparent" type="bool" value="true"/>
  </properties>
  <image width="64" height="64" source="thin_walls/wall35_vertical.png"/>
 </tile>
</tileset>
