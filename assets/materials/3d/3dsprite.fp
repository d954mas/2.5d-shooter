varying mediump vec2 var_texcoord0;
varying mediump vec4 pos;
uniform lowp sampler2D DIFFUSE_TEXTURE;
uniform lowp sampler2D LIGHT_MAP_TEXTURE;
uniform mediump vec4 fog_color;
uniform mediump vec4 light_map;
uniform mediump vec4 fog; //x start distance y end dist.
uniform lowp vec4 flash;
void main()
{    
    float dist = gl_FragCoord.z/gl_FragCoord.w;
    vec4 spriteColor = texture2D(DIFFUSE_TEXTURE, var_texcoord0.xy);
    vec4 lightColor = texture2D(LIGHT_MAP_TEXTURE, vec2(pos.x/light_map.x,pos.z/light_map.y));
    vec3 color  = spriteColor.rgb * lightColor.rgb;

    float f = 1.0 /exp((dist-fog.x) * fog.z);
    f = clamp(f, 0.0, 1.0);
    vec3 total_color  = (1.0-f) * fog_color.rgb +  f * color.rgb;
    total_color = mix(vec3(0.0),total_color, f);

    gl_FragColor.rgb = (vec3(1.0) * flash.x + total_color.rgb * (1.0 - flash.x))*spriteColor.a;
    gl_FragColor.a = spriteColor.a;
}
