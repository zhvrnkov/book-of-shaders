#include "base.glsl"

float noise(int x, int y)
{
    int n = x + y * 57;
    n = (n << 13) ^ n;
    int value = (n * (n * n * 15731 + 789221) + 1376312589);
    float normalizedValue = float( value & 0x7fffffff) / 1073741824.0; // in range [0...2]
    return ( 1.0 - normalizedValue); // in range [-1...1]}
}

float smoothNoise(int x, int y)
{
    float corners = ( noise(x-1, y-1)+noise(x+1, y-1)+noise(x-1, y+1)+noise(x+1, y+1) ) / 16.0;
    float sides   = ( noise(x-1, y)  +noise(x+1, y)  +noise(x, y-1)  +noise(x, y+1) ) /  8.0;
    float center  =  noise(x, y) / 4.0;
    return corners + sides + center;
}

float interpolate(float a, float b, float t)
{
    // {
    //     return mix(a, b, t);
    // }
    {
        float ft = t * 3.1415927;
	    float f = (1.0 - cos(ft)) * .5;
	    return  a*(1.0-f) + b*f;
    }
}

float interpolatedNoise(vec2 xy)
{
    ivec2 ixy = ivec2(floor(xy));
    vec2 fxy = fract(xy);

    int integer_X = ixy.x;
    int integer_Y = ixy.y;
    float v1 = smoothNoise(integer_X,     integer_Y);
    float v2 = smoothNoise(integer_X + 1, integer_Y);
    float v3 = smoothNoise(integer_X,     integer_Y + 1);
    float v4 = smoothNoise(integer_X + 1, integer_Y + 1);

    float i1 = interpolate(v1, v2, fxy.x);
    float i2 = interpolate(v3, v4, fxy.x);

    return interpolate(i1, i2, fxy.y);
}

float interpolatedNoise3d(vec3 xyz)
{
    float z1 = interpolatedNoise(xyz.xy);
    float z2 = interpolatedNoise(xyz.xy + 1.0);

    return interpolate(z1, z2, fract(xyz.z));
}

float perlinNoise2d(vec2 xy) 
{
    float total = 0.0;
    float persistence = 0.5;
    int numberOfOctaves = 8;

    for (int i = 0; i < numberOfOctaves; i++) {
        float frequency = float(1 << i);
        float amplitude = pow(persistence, float(i));
        total += interpolatedNoise(xy * frequency) * amplitude;
    }

    return total;;
}

float perlinNoise3d(vec3 xyz) 
{
    float total = 0.0;
    float persistence = 0.5;
    int numberOfOctaves = 8;

    for (int i = 0; i < numberOfOctaves; i++) {
        float frequency = float(1 << i);
        float amplitude = pow(persistence, float(i));
        total += interpolatedNoise3d(vec3(xyz.xy * frequency, xyz.z)) * amplitude;
    }

    return total;;
}

float rand1d(float x)
{
    float frequency = 123.456;
    float amplitude = 843.432;

    return fract(sin(frequency * x) * amplitude);
}

float noise1d(float x) 
{
    float i = floor(x);
    float f = fract(x);

    float i1 = rand1d(i);
    float i2 = rand1d(i + 1.0);

    return interpolate(i1, i2, f);
}

float noise2d(vec2 xy) 
{
    float y1 = noise1d((xy.x));
    float y2 = noise1d((xy.x) + 32.0);

    return interpolate(y1, y2, fract(xy.y));
}

void main()
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    vec2 res;
    res = vec2(iResolution.xy);
    res = vec2(64);
    uv = floor(uv * res) / res;
    uv.y = 1.0 - uv.y;
    vec2 awUV = apsectAwareUV(uv, iResolution.xy);
    vec2 xy = uv2coord(uv);

    vec3 color;
    // color = vec3(0.5 + 0.5 * perlinNoise2d(10.0 * uv));
    // color = vec3(0.5 + 0.5 * perlinNoise3d(vec3(10.0 * uv, iGlobalTime)));

    // color = vec3(rand1d(uv.x));
    // color = vec3(rand1d(dot(uv, vec2(1, res.x))));
    // color = vec3(noise1d(uv.x));
    color = vec3(noise1d(dot(uv, vec2(1 << 5, 1 << 10))));

    gl_FragColor = vec4(color, 1);
}