<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.2" tiledversion="1.2.4" name="objects" tilewidth="64" tileheight="64" tilecount="4" columns="0">
 <grid orientation="orthogonal" width="1" height="1"/>
 <tile id="1">
  <properties>
   <property name="spawn_point" type="bool" value="true"/>
  </properties>
  <image width="64" height="64" source="objects/spawn_point_top.png"/>
 </tile>
 <tile id="2">
  <properties>
   <property name="rotation" type="float" value="180"/>
   <property name="spawn_point" type="bool" value="true"/>
  </properties>
  <image width="64" height="64" source="objects/spawn_point_bottom.png"/>
 </tile>
 <tile id="3">
  <properties>
   <property name="rotation" type="float" value="270"/>
   <property name="spawn_point" type="bool" value="true"/>
  </properties>
  <image width="64" height="64" source="objects/spawn_point_right.png"/>
 </tile>
 <tile id="4">
  <properties>
   <property name="rotation" type="float" value="90"/>
   <property name="spawn_point" type="bool" value="true"/>
  </properties>
  <image width="64" height="64" source="objects/spawn_point_left.png"/>
 </tile>
</tileset>
