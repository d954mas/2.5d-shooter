varying highp vec4 var_position;
varying mediump vec3 var_normal;
varying mediump vec2 var_texcoord0;
varying mediump vec4 var_light;

uniform lowp sampler2D DIFFUSE_TEXTURE;
uniform lowp sampler2D LIGHT_MAP_TEXTURE;

uniform mediump vec4 fog_color;
uniform mediump vec4 light_map;
uniform mediump vec4 fog; //x start distance y end dist.
uniform lowp sampler2D tex0;
uniform lowp vec4 tint;


void main()
{
    float dist = gl_FragCoord.z/gl_FragCoord.w;
    vec4 lightColor = texture2D(LIGHT_MAP_TEXTURE, vec2(var_position.x/light_map.x,var_position.z/light_map.y));
    // Pre-multiply alpha since all runtime textures already are
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    vec4 spriteColor = texture2D(DIFFUSE_TEXTURE, var_texcoord0.xy) * tint_pm;
    if(spriteColor.a < 0.01){discard;}

    vec3 color  = spriteColor.rgb * lightColor.rgb;

    float f = 1.0 /exp((dist-fog.x) * fog.z);
    f = clamp(f, 0.0, 1.0);
    vec3 total_color  = (1.0-f) * fog_color.rgb +  f * color.rgb;
    total_color = mix(vec3(0.0),total_color, f);

    // Diffuse light calculations
    vec3 ambient_light = vec3(0.2);
    vec3 diff_light = vec3(normalize(var_light.xyz - var_position.xyz));
    diff_light = max(dot(var_normal,diff_light), 0.0) + ambient_light;
    diff_light = clamp(diff_light, 0.0, 1.0);

    
    gl_FragColor.rgb = total_color.rgb * diff_light *spriteColor.a;
    gl_FragColor.a = spriteColor.a;
    
}

