#include "base.glsl"



void main() 
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;
    vec2 awUV = apsectAwareUV(uv, iResolution.xy);

    vec4 color;
    // rectangle shapes
    // {
    //     vec2 coord = uv * 2.0 - 1.0;
    //     vec2 center = vec2(0.0);
    //     vec2 size = vec2(1.0);
        
    //     vec2 hs = size / 2.0;
    //     float lb = center.x - hs.x;
    //     float rb = center.x + hs.x;
    //     float bb = center.y - hs.y;
    //     float tb = center.y + hs.y;

    //     int type = 1;
    //     float edge = 0.01;
    //     float hor = shape(lb, rb, coord.x, type, edge);
    //     float vert = shape(bb, tb, coord.y, type, edge);
    //     color = vec4(vec3(hor * vert), 1.0);
    // }

    // meta balls
    // {
    //     vec2 awUV = apsectAwareUV(uv, iResolution.xy);

    //     float d = 0.0;

    //     vec2 center = vec2(0.5);
    //     d += 1.0 - pow(distance(center, awUV), 0.5);

    //     vec2 center2 = vec2(0.25);
    //     d += 1.0 - pow(distance(center2, awUV), 0.5);
    //     d = smoothstep(1.1, 1.2, d);

    //     color = vec4(vec3(d), 1.0);
    // }

    // {
    //     vec2 xy = apsectAwareUV(uv, iResolution.xy);

    //     float t = pow(cos(time * 0.5), 2.0);
    //     vec2 center1 = vec2(mix(0.5, 0.0, t));
    //     vec2 center2 = vec2(mix(0.5, 1.0, t));

    //     // float d = distance(center1, xy) * distance(center2, xy);
    //     // float d = min(distance(center1, xy), distance(center2, xy));
    //     // float d = max(distance(center1, xy), distance(center2, xy));
    //     float d = pow(distance(center1, xy), distance(center2, xy));
    //     // float edge = 0.1;
    //     // d = smoothstep(edge, edge - 0.1, d);

    //     color = vec4(vec3(d), 1.0);
    // }
    // rectangle shapes
    // {
    //     vec2 coord = uv * 2.0 - 1.0;
    //     vec2 center = vec2(0.0);
    //     vec2 size = vec2(1.0);
        
    //     vec2 hs = size / 2.0;
    //     float lb = center.x - hs.x;
    //     float rb = center.x + hs.x;
    //     float bb = center.y - hs.y;
    //     float tb = center.y + hs.y;

    //     int type = 3;
    //     float edge = 0.01;
    //     float hor = shape(lb, rb, coord.x, type, edge);
    //     float vert = shape(bb, tb, coord.y, type, edge);
    //     color = vec4(vec3(hor * vert), 1.0);
    // }

    // shape 2d 
    {
        vec2 coord = uv2coord(awUV);

        vec2 scaleFactor = vec2(0.2);
        float angle = iGlobalTime;
        
        vec2 translation = vec2(cos(iGlobalTime), sin(iGlobalTime));

        mat3 matrix = srt(scaleFactor, angle, translation);

        int type = 5;
        float edge = 0.1;
        coord = (matrix * vec3(coord, 1)).xy;
        color = vec4(vec3(shape2d(coord, type, edge)), 1.0);
    }

    // meta balls
    // {
    //     vec2 awUV = apsectAwareUV(uv, iResolution.xy);

    //     float d = 0.0;

    //     vec2 center = vec2(0.5);
    //     d += 1.0 - pow(distance(center, awUV), 0.5);

    //     vec2 center2 = vec2(0.25);
    //     d += 1.0 - pow(distance(center2, awUV), 0.5);
    //     d = smoothstep(1.1, 1.2, d);

    //     color = vec4(vec3(d), 1.0);
    // }

    // {
    //     vec2 xy = apsectAwareUV(uv, iResolution.xy);

    //     float t = pow(cos(time * 0.5), 2.0);
    //     vec2 center1 = vec2(mix(0.5, 0.0, t));
    //     vec2 center2 = vec2(mix(0.5, 1.0, t));

    //     float d = distance(center1, xy) * distance(center2, xy);
    //     // float d = min(distance(center1, xy), distance(center2, xy));
    //     // float d = max(distance(center1, xy), distance(center2, xy));
    //     // float d = pow(distance(center1, xy), distance(center2, xy));
    //     float edge = 0.1; d = smoothstep(edge, edge - 0.1, d);

    //     color = vec4(vec3(d), 1.0);
    // }

    gl_FragColor = color;
}