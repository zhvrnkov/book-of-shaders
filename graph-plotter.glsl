#include "base_noise.glsl"

#define pi 3.1415926535897932384626433832795028841971693993751058209749445923078164

float intNoise(int x)
{
    x = (x << 13) ^ x;
    int value = (x * (x * x * 15731 + 789221) + 1376312589);
    float normalizedValue = float( value & 0x7fffffff) / 1073741824.0; // in range [0...2]
    return ( 1.0 - normalizedValue); // in range [-1...1]
}

float f1(float x)
{
    x *= 10.0;
    int i = int(floor(x));
    float f = makeFraction(vec3(x, 0, 0), 2).x;

    float n = intNoise(i);
    float nn = intNoise(i + 1);

    return mix(n, nn, f);
}

float sdCircleLine(float radius, float thikness, vec2 xy)
{
    float sdInner = sdCircle(radius - thikness / 2.0, xy);
    float sdOuter = sdCircle(radius + thikness / 2.0, xy);

    return clamp(sdOuter, 0., 1.) + clamp(-sdInner, 0., 1.);
    return sdOuter;
}

float sdf2line( in vec2 p, in vec2 a, in vec2 b )
{
    vec2 pa = p - a;
    vec2 ba = b - a;
    // dot(ba, ba) insted of length(ba) because we also need to 
    // normalize pa projection to [0...1] from [0...|ba|]
    float proj = clamp(dot(pa, ba) / dot(ba, ba), 0., 1.);
    return distance(mix(a, b, proj), p);
}

float bellCurve(float value, float d)
{
    return smoothstep(-d, 0., value) - smoothstep(0., +d, value);
}

float sdf2fn(vec2 xy, float deltaX)
{
    float x1 = xy.x;
    float y1 = f1(x1);
    float x2 = xy.x + deltaX;
    float y2 = f1(x2);
    float sd = sdf2line(xy, vec2(x1, y1), vec2(x2, y2));
    return sd;
}

#define samples 1.
float sdf2fnms(vec2 xy, vec2 delta)
{
    float result = 0.;
    for (float ix = -samples; ix < samples; ix++) {
        float x1 = xy.x + ix * delta.x;
        float x2 = x1 + delta.x;
        float y1 = f1(x1);
        float y2 = f1(x2);
        for (float iy = -samples; iy < samples; iy++) {
            float y = xy.y + iy * delta.y;
            float sd = sdf2line(vec2(x1, y), vec2(x1, y1), vec2(x2, y2));
            result += sd;
        }
    }
    return result;
}

float fnPixelValue(vec2 xy, vec2 delta)
{
    float sd00 = sdf2fn(xy, delta.x);
    float sd01 = sdf2fn(xy + vec2(0,1) * delta, delta.x);
    float sd10 = sdf2fn(xy + vec2(1,0) * delta, delta.x);
    float sd11 = sdf2fn(xy + vec2(1,1) * delta, delta.x);

    float dy = abs((sd01 - sd00) / delta.y);
    float dx = abs((sd10 - sd00) / delta.x);
    float sd = (sd00 + sd01 + sd10 + sd11) / 4.;
    return dy;
    return smoothstep(0., 0.05 + dy * 0.1, sd);
    // vec2 xy1 = xy;
    // vec2 xy2 = xy + delta;

    // float y1 = f1(xy1.x);
    // float y2 = f1(xy2.x);

    // return y1 - xy1.y;
}

void main()
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;
    vec2 awUV = apsectAwareUV(uv, iResolution.xy);
    vec2 xy = uv2coord(uv);

    // float dx = 0.001;
    // float x = xy.x * 30.0;
    // float y = 0.1 * f1(x);
    // float yn = 0.1 * f1(x + dx);
    // float deriv = (yn - y) / dx;

    // float plot = abs(xy.y - y);
    // float bias = 0.015;
    // plot = smoothstep(bias + abs(deriv) * 3.0 * bias, 0.0, plot);

    // float derivPlot = abs(xy.y - deriv);
    // plot += smoothstep(0.05, 0.0, derivPlot);

    vec3 color;
    // sdf 
    {
    float sd;
    // sd = sdf2fnms(xy, 1. / iResolution.xy);
    float d = 1. / iResolution.y;
    sd = fnPixelValue(xy, 1. / iResolution.xy);
    // value = pow(value, 1./2.2);
    color = vec3(sd);
    }

    // {
    //     float sd;
    //     vec2 p1 = vec2(-0.5, 0.);
    //     vec2 p2 = vec2(0.5, 0.);
    //     sd = sdf2line(xy, p1, p2);

    //     color = vec3(sd);
    // }

    // plot
    // {
    //     float x = 1. * xy.x;
    //     float y = f1(x);
    //     float x1 = x + 0.005;
    //     float y1 = f1(x1);
    //     vec2 delta = vec2(x1, y1) - vec2(x, y);
    //     float cosPhi = delta.x / length(delta);
    //     float height = 0.01 / 2.0 / cosPhi;
    //     float v = abs(xy.y - y) - height;
    //     v = smoothstep(0., 0.01, v);

    //     color = vec3(v);
    // }
    // vec2 la = vec2(-0.5, 0.);
    // vec2 lb = vec2(0.5, 0.);
    // color = vec3(bellCurve(sdf2line(xy, la, lb), d));

    gl_FragColor = vec4(color, 1.0);
}