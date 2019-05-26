varying mediump vec4 var_position;
varying mediump vec3 var_normal;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D tex0;
uniform lowp vec4 tint;
uniform lowp vec4 full_tint;

void main()
{
    // Pre-multiply alpha since all runtime textures already are
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    vec4 full_tint_pm = vec4(full_tint.xyz * full_tint.w, full_tint.w);
    vec4 color = texture2D(tex0, var_texcoord0.xy);
    color = color * full_tint_pm;
    if (color.r == color.g) { 
        color = color * tint_pm;
    }
    gl_FragColor = vec4(color.rgba);
}