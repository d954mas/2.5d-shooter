varying mediump vec2 var_texcoord0;

uniform lowp sampler2D texture_sampler;
uniform lowp vec4 tint;

void main()
{
    vec4 spriteColor = texture2D(texture_sampler, var_texcoord0.xy);
    if(spriteColor.a < 0.01){discard;}
    // Pre-multiply alpha since all runtime textures already are
    lowp vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    gl_FragColor = texture2D(texture_sampler, var_texcoord0.xy) * tint_pm;
}
