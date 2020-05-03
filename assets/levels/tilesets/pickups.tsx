<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.2" tiledversion="1.3.3" name="pickups" tilewidth="64" tileheight="64" tilecount="6" columns="0">
 <grid orientation="orthogonal" width="1" height="1"/>
 <properties>
  <property name="type" value="pickups"/>
 </properties>
 <tile id="0">
  <properties>
   <property name="pickup_type" value="ammo_pistol"/>
   <property name="scale" type="float" value="0.5"/>
   <property name="sprite_origin_y" type="float" value="16"/>
  </properties>
  <image width="64" height="64" source="../tiles/pickups/pickup_ammo_pistol.png"/>
 </tile>
 <tile id="1">
  <properties>
   <property name="pickup_type" value="hp"/>
   <property name="scale" type="float" value="0.5"/>
   <property name="sprite_origin_y" type="float" value="16"/>
  </properties>
  <image width="64" height="64" source="../tiles/pickups/pickup_hp.png"/>
 </tile>
 <tile id="2">
  <properties>
   <property name="pickup_key_type" value="blue"/>
   <property name="pickup_type" value="key"/>
   <property name="scale" type="float" value="0.25"/>
   <property name="sprite_origin_y" type="float" value="32"/>
  </properties>
  <image width="64" height="64" source="../tiles/pickups/pickup_key_blue.png"/>
 </tile>
 <tile id="3">
  <properties>
   <property name="pickup_key_type" value="green"/>
   <property name="pickup_type" value="key"/>
   <property name="scale" type="float" value="0.25"/>
   <property name="sprite_origin_y" type="float" value="32"/>
  </properties>
  <image width="64" height="64" source="../tiles/pickups/pickup_key_green.png"/>
 </tile>
 <tile id="4">
  <properties>
   <property name="pickup_key_type" value="white"/>
   <property name="pickup_type" value="key"/>
   <property name="scale" type="float" value="0.25"/>
   <property name="sprite_origin_y" type="float" value="32"/>
  </properties>
  <image width="64" height="64" source="../tiles/pickups/pickup_key_white.png"/>
 </tile>
 <tile id="5">
  <properties>
   <property name="pickup_key_type" value="yellow"/>
   <property name="pickup_type" value="key"/>
   <property name="scale" type="float" value="0.25"/>
   <property name="sprite_origin_y" type="float" value="32"/>
  </properties>
  <image width="64" height="64" source="../tiles/pickups/pickup_key_yellow.png"/>
 </tile>
</tileset>
