#include "base.glsl"

void main() 
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;

    vec4 color;

    // gradient
    // {
    //     vec2 aps[] = vec2[](
    //         vec2(0),
    //         vec2(1.0, 0),
    //         vec2(1.0, 1.0),
    //         vec2(0, 1.0)
    //     );
    //     vec4 a = vec4(1.0, 0, 0, 1.0);
    //     // float t = fract(time * 0.1);
    //     float t = pow(sin(0.5 * time), 2.0);
    //     vec2 ap = mix(aps, t);
    //     // vec2 ap = vec2(0, 0);
    //     vec4 b = vec4(0, 0, 1.0, 1.0);
    //     vec2 bp = vec2(1, 1);

    //     {
    //         bp = oppositeUV(ap);
    //     }

    //     color = gradient(a, ap, b, bp, uv, time);
    // }
    // gradient by angle
    // {
    //     vec4 a = vec4(1.0, 0, 0, 1.0);
    //     vec4 b = vec4(0, 0, 1.0, 1.0);

    //     float angle = time * 1.5;
    //     float scale = sin(time);

    //     float ca = cos(angle);
    //     float sa = sin(angle);
    //     vec2 ix = vec2(ca, sa);
    //     vec2 iy = vec2(-sa, ca);

    //     mat2 matrix = mat2(ix, iy);

    //     vec2 coord = uv * 2.0 - 1.0;
    //     uv = (matrix * coord) * 0.5 + 0.5;

    //     float t = linear2D21D(uv);
    //     color = mix(a, b, t);
    // }

    // field gradient
    // {
    //     vec4 a = vec4(1.0, 0, 0, 1.0);
    //     vec2 ap = vec2(0.5);
    //     vec4 b = vec4(0, 0, 1.0, 1.0);
    //     vec2 bp = vec2(0.1);

    //     float delta  = 1.0;
    //     float radius = 0.7;

    //     float afield = 1.0 - smoothstep(radius - delta, radius + delta, distance(uv, ap));
    //     float bfield = 1.0 - smoothstep(radius - delta, radius + delta, distance(uv, bp));

    //     color = afield * a + bfield * b;
    // }
 
    // gradient between 4 points (4 corners)
    // {
    //     vec4 color0 = rgb(93, 108, 144);
    //     vec4 color1 = rgb(56, 57, 62);
    //     vec4 color2 = rgb(245, 178, 74);
    //     vec4 color3 = rgb(63, 31, 12);

    //     color = quad_mix(color0, color1, color2, color3, uv);
    // }

    // triangle interpolation
    // {
    //     vec2 coords[] = vec2[](
    //         vec2(0.25, 0.25),
    //         vec2(0.75, 0.25),
    //         vec2(0.75, 0.75)
    //     );
    //     bool isPixelInTriangle = false;
    //     {
    //         vec2 topMostCoord;

    //     }
    //     color = vec4(1.0);
    // }

    // horizontal grdient in n colors
    // {
    //     float value = uv.x;
    //     vec4 colors[] = vec4[](
    //         vec4(1.0, 0.0, 0.0, 1.0),
    //         vec4(1.0, 1.0, 0.0, 1.0),
    //         vec4(0.0, 1.0, 0.0, 1.0),
    //         vec4(0.0, 1.0, 1.0, 1.0),
    //         vec4(0.0, 0.0, 1.0, 1.0),
    //         vec4(1.0, 0.0, 1.0, 1.0),
    //         vec4(1.0, 0.0, 0.0, 1.0)
    //     );
    //     float lm1 = float(colors.length() - 1);
    //     int integerPart = int(floor(value * lm1));
    //     float fractPart = fract(value * lm1);
    //     int baseIndex = integerPart;
    //     int nextIndex = (integerPart + 1) % colors.length();
    //     color = mix(colors[baseIndex], colors[nextIndex], fractPart);
    // }

    {
        vec2 xy = uv2coord(uv);

        float radius = length(xy);
        float angle = atan3(xy.y, xy.x);

        color = vec4(hsb2rgb(vec3(angle / TWO_PI, radius * 2.0, 1.0)), 1.0);

    }


    gl_FragColor = color;
}