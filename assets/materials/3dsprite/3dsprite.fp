varying mediump vec2 var_texcoord0;
varying mediump vec4 pos;
uniform lowp sampler2D DIFFUSE_TEXTURE;
uniform lowp sampler2D LIGHT_MAP_TEXTURE;
uniform mediump vec4 fog_color;
uniform mediump vec4 light_map;
uniform mediump vec4 fog; //x start distance y end dist. z for exponent
void main()
{
    vec4 spriteColor = texture2D(DIFFUSE_TEXTURE, var_texcoord0.xy);
    if(spriteColor.a < 0.01){discard;}
    vec4 lightColor = texture2D(LIGHT_MAP_TEXTURE, vec2((pos.x+0.00001)/light_map.x,(pos.z+0.00001)/light_map.y));// multiply to fix wall on cell borders
    vec3 color  = spriteColor.rgb * lightColor.rgb;
    gl_FragColor = vec4(color,spriteColor.a);
}
