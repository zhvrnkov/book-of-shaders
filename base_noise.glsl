#include "base.glsl"

float rand1(float x)
{
    return rand(vec2(x, 1));
}

int nearestNeighbor = 0;
int linear = 1;
int cubic = 2;
int quintic = 3;

vec3 makeFraction(vec3 x, int mode)
{
    vec3 fx = fract(x);
    switch (mode) {
        case 0: return vec3(0);
        case 1: return fx;
        case 2: return smoothstep(0.0, 1.0, fx);
        case 3: return fx*fx*fx*(fx*(fx*6.-15.)+10.);
    }
}

float noise1d(float x, int mode)
{
    float i = floor(x);
    float f = makeFraction(vec3(x, 0, 0), mode).x;
    return mix(rand1(i), rand1(i + 1.0), f);
}

float noise2d(vec2 x, int type)
{
    vec2 is = floor(x);
    vec2 fs = makeFraction(vec3(x, 0), type).xy;

    float r00 = rand(is);
    float r11 = rand(is + 1.0);
    float r10 = rand(is + vec2(1, 0));
    float r01 = rand(is + vec2(0, 1));

    float rx0 = mix(r00, r10, fs.x);
    float rx1 = mix(r01, r11, fs.x);

    return mix(rx0, rx1, fs.y);
}

float noise3d(vec3 xyz, int type)
{
    vec3 i = floor(xyz);
    vec3 f = makeFraction(xyz, 2);

    float z0;
    {
        float t = mix(rand3(i + vec3(0, 0, 0)), rand3(i + vec3(1, 0, 0)), f.x);
        float b = mix(rand3(i + vec3(0, 1, 0)), rand3(i + vec3(1, 1, 0)), f.x);
        z0 = mix(t, b, f.y);
    }

    float z1;
    {
        float t = mix(rand3(i + vec3(0, 0, 1)), rand3(i + vec3(1, 0, 1)), f.x);
        float b = mix(rand3(i + vec3(0, 1, 1)), rand3(i + vec3(1, 1, 1)), f.x);
        z1 = mix(t, b, f.y);
    }

    return mix(z0, z1, f.z);
}

vec2 gradient(vec2 x, vec2 step)
{
    int type = cubic;
    float mm = noise2d(x, type);
    float tm = noise2d(x + vec2( 0, -1) * step, type);
    float bm = noise2d(x + vec2( 0,  1) * step, type);
    float ml = noise2d(x + vec2(-1,  0) * step, type);
    float mr = noise2d(x + vec2( 1,  0) * step, type);

    float dx = ml - mr;
    float dy = tm - bm;
    vec2 dp = 2.0 * step;

    return vec2(dx, dy) / dp;
}

float between2noises(vec2 uv, int type, float t)
{
    float scale = 1.0;
    float integer1 = floor(82.0 * rand1(floor(iGlobalTime - 1.0)));
    float integer2 = floor(82.0 * rand1(floor(iGlobalTime)));
    float fraction = makeFraction(vec3(iGlobalTime), 3).x;
    float noise1 = noise2d(4.0 * uv + integer1 * scale, type);
    float noise2 = noise2d(4.0 * uv + integer2 * scale, type);

    return mix(noise1, noise2, t);
}
