<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.2" tiledversion="1.2.4" name="pickups" tilewidth="64" tileheight="64" tilecount="6" columns="0">
 <grid orientation="orthogonal" width="1" height="1"/>
 <tile id="1">
  <properties>
   <property name="global_rotation" type="bool" value="true"/>
   <property name="look_at_player" type="bool" value="false"/>
   <property name="pickup" type="bool" value="true"/>
   <property name="pickup_key" value="ammo_pistol"/>
   <property name="scale" type="float" value="0.25"/>
  </properties>
  <image width="32" height="32" source="../../images/game/pickups/pickup_ammo_pistol.png"/>
 </tile>
 <tile id="2">
  <properties>
   <property name="global_rotation" type="bool" value="true"/>
   <property name="look_at_player" type="bool" value="false"/>
   <property name="pickup" type="bool" value="true"/>
   <property name="pickup_key" value="hp"/>
   <property name="scale" type="float" value="0.25"/>
  </properties>
  <image width="32" height="32" source="../../images/game/pickups/pickup_hp.png"/>
 </tile>
 <tile id="3">
  <properties>
   <property name="change_state" value="keys.blue"/>
   <property name="global_rotation" type="bool" value="true"/>
   <property name="look_at_player" type="bool" value="false"/>
   <property name="pickup" type="bool" value="true"/>
   <property name="scale" type="float" value="0.25"/>
  </properties>
  <image width="64" height="64" source="../../images/game/pickups/pickup_key_blue.png"/>
 </tile>
 <tile id="4">
  <properties>
   <property name="change_state" value="keys.green"/>
   <property name="global_rotation" type="bool" value="true"/>
   <property name="look_at_player" type="bool" value="false"/>
   <property name="pickup" type="bool" value="true"/>
   <property name="scale" type="float" value="0.25"/>
  </properties>
  <image width="64" height="64" source="../../images/game/pickups/pickup_key_green.png"/>
 </tile>
 <tile id="5">
  <properties>
   <property name="change_state" value="keys.white"/>
   <property name="global_rotation" type="bool" value="true"/>
   <property name="look_at_player" type="bool" value="false"/>
   <property name="pickup" type="bool" value="true"/>
   <property name="scale" type="float" value="0.25"/>
  </properties>
  <image width="64" height="64" source="../../images/game/pickups/pickup_key_white.png"/>
 </tile>
 <tile id="6">
  <properties>
   <property name="change_state" value="keys.yellow"/>
   <property name="global_rotation" type="bool" value="true"/>
   <property name="look_at_player" type="bool" value="false"/>
   <property name="pickup" type="bool" value="true"/>
   <property name="scale" type="float" value="0.25"/>
  </properties>
  <image width="64" height="64" source="../../images/game/pickups/pickup_key_yellow.png"/>
 </tile>
</tileset>
