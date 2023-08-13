#include "base.glsl"

#define SQRT_2 1.4142


void main()
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;
    vec2 awUV = apsectAwareUV(uv, iResolution.xy);

    vec2 gridSize = vec2(24.0);
    ivec2 index = ivec2(ceil(awUV * gridSize));
    awUV = fract(awUV * gridSize);
    vec2 coord = uv2coord(awUV);
    vec3 color;

    // {
    //     mat3 t = srt(vec2(SQRT_2), PI / 4.0, vec2(0.0));
    //     coord = (t * vec3(coord, 1.0)).xy;
    //     color = vec3(shape2d(coord, 1, 0.01));
    // }

    // {
    //     float delta = 0.01;
    //     mat3 t = srt(vec2(1.0), PI / 4.0, vec2(0.0));
    //     coord = (t * vec3(coord, 1.0)).xy;
    //     float sdc = sdCircle(0.5, coord);
    //     float sdb = sdBox(vec2(SQRT_2), coord);
    //     float sd = mix(sdc, sdb, pow(sin(iGlobalTime), 2.0));
    //     color = vec3(smoothstep(-delta, +delta, sd));
    // }

    // {
    //     float delta = 0.00001;
    //     float sdb1 = sdBox(vec2(1.95), coord);
    //     float value1 = smoothstep(-delta, +delta, sdb1);
    //     value1 = 1.0 - value1;

    //     mat3 t = srt(vec2(1.0), PI / 4.0, vec2(0.0));
    //     coord = (t * vec3(coord, 1.0)).xy;
    //     float sdb2 = sdBox(vec2(1.7 * SQRT_2), coord);
    //     float value2 = smoothstep(-delta, +delta, sdb2);

    //     float sdb3 = sdBox(vec2(1.76 * SQRT_2), coord);
    //     float value3 = smoothstep(-delta, +delta, sdb3);
    //     value2 = value2 - 2.0 * value3;

    //     color = vec3(value1 - value2);
    // }

    // {
    //     vec2 wallUV = apsectAwareUV(uv, iResolution.xy);
    //     wallUV *= 9.0;
    //     float isEvenY = step(1.0, mod(wallUV.y, 2.0)) * 2.0 - 1.0;
    //     float isEvenX = step(1.0, mod(wallUV.x, 2.0)) * 2.0 - 1.0;


    //     float interval = 2.0;
    //     float t = mod(iGlobalTime, interval);

    //     vec2 shift = vec2(step(t, interval / 2.0) * isEvenY * iGlobalTime,
    //                       step(interval / 2.0, t) * isEvenX * iGlobalTime);

    //     wallUV += shift;
    //     wallUV = fract(wallUV);

    //     vec2 coord = uv2coord(wallUV);

    //     float sd = sdCircle(0.5, coord);
    //     float d = 0.01;
    //     float value = smoothstep(-d, +d, sd);

    //     color = vec3(value);
    // }

    {
        int type = 3;
        vec2 ts[4] = vec2[](
            vec2(1, 1),
            vec2(1, -1),
            vec2(-1, 1),
            vec2(-1, -1)
        );
        
        mat3 m = srt(vec2(1.0), PI / 4.0, ts[index.x % 2 + index.y % 2]);

        coord = (m * vec3(coord, 1.0)).xy;

        float d = 0.01;
        float sd = sdBox(vec2(2.0 * SQRT_2), coord);
        float value = smoothstep(-d, +d, sd);

        color = vec3(value);
    }

    gl_FragColor = vec4(color, 1.0);
}
