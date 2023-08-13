#include "base.glsl"

void main()
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;
    vec2 awUV = apsectAwareUV(uv, iResolution.xy);
    vec2 coord = uv2coord(uv);

    vec3 color;

    // {
    //     float r = rand(1.0 * iGlobalTime + coord);
    //     color = vec3(pow(r, 1.0));
    // }

    // {
    //     awUV *= 10.0;
    //     vec2 integer = floor(awUV);
    //     vec2 fractional = fract(awUV);

    //     color = vec3(rand(integer));
    //     // color = vec3(fractional, 0);
    // }

    // {
    //     awUV *= 10.0;
    //     vec2 integer = floor(awUV);
    //     vec2 fraction = fract(awUV);

    //     vec2 coord = uv2coord(fraction);

    //     float angle;
    //     // angle = PI * 0.25 * floor(rand(integer) * 4.0);
    //     angle = (rand(integer + floor(iGlobalTime)) > 0.5 ? 0.25 : 0.75) * PI;
    //     // angle = (rand(integer) > 0.5 ? 0.5 : 0.0) * PI;
    //     // angle = rand(awUV + iGlobalTime) * PI;
    //     // angle = iGlobalTime;

    //     mat2 m = rotate2d(angle);
    //     coord = m * coord;
    //     fraction = coord2uv(coord);

    //     float lf = length(fraction);
    //     float lf1 = length(fraction - 1.0);
    //     float value1 = step(lf, 0.6) - step(lf, 0.4);
    //     float value2 = step(lf1, 0.6) - step(lf1, 0.4);

    //     float value = value1 + value2;

    //     color = vec3(value);
    // }

    {
        uv *= vec2(1.0, 64.0);

        vec2 integer = floor(uv);
        vec2 fraction = fract(uv);
        vec2 t = vec2(rand(integer) + floor(iGlobalTime * 0.1), 1);

        float direction;
        {
            // direction = integer.y > 0.0 ? 1.0 : -1.0;
            direction = 1.0;
            direction *= rand(t) > 0.5 ? 1.0 : -1.0;
        }

        float magnitude;
        {
            magnitude = rand(t);
        }
        float speed = direction * magnitude;

        float stretch;
        {
            stretch = 1.0 - rand(t) * 0.5;
        }

        float x = discreted(
            integer.y + fraction.x * stretch + iGlobalTime * speed,
            100.0
        );

        float noise = rand(vec2(x, 1.0));

        float value = step(0.5, noise);

        float progress = 1.0 - step(iGlobalTime, integer.y + fraction.x);

        color = vec3(value * progress);
    }


    gl_FragColor = vec4(color, 1);
}
