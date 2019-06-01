varying mediump vec2 var_texcoord0;
varying mediump float dist;
uniform lowp sampler2D DIFFUSE_TEXTURE;
uniform mediump vec4 fog_color;
uniform mediump vec4 fog; //x start distance y end dist. z for exponent
void main()
{
    float f = 1.0 /exp((dist-fog.x) * fog.z);
    // float f = (fog.y - dist)/(fog.y - fog.x);
    f = clamp(f, 0.0, 1.0);
    vec4 texColor = texture2D(DIFFUSE_TEXTURE, var_texcoord0.xy);
    vec3 color  = (1.0-f) * fog_color.rgb +  f * texColor.rgb;
    //gl_FragColor = vec4(dist/10);
    color = mix(vec3(0.0),color, texColor.a);
    if(texColor.a < 0.01){
        discard;
    }
    gl_FragColor = vec4(color,texColor.a);
}
