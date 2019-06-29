<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.2" tiledversion="1.2.4" name="enemies" tilewidth="64" tileheight="64" tilecount="2" columns="0">
 <grid orientation="orthogonal" width="1" height="1"/>
 <tile id="1">
  <properties>
   <property name="enemy" type="bool" value="true"/>
   <property name="name" value="blob"/>
  </properties>
  <image width="64" height="64" source="../../images/game/enemies/blob/idle/blob_idle_1.png"/>
 </tile>
 <tile id="2">
  <properties>
   <property name="delay" type="float" value="2"/>
   <property name="enemy" type="bool" value="true"/>
   <property name="name" value="spawner_enemy"/>
   <property name="spawn_enemy" value="blob"/>
   <property name="spawner" type="bool" value="true"/>
  </properties>
  <image width="64" height="64" source="objects/spawner.png"/>
 </tile>
</tileset>
