#define PI 3.141592653589
#define TWO_PI 6.2831853072
#define DPI 2.0 * PI

float sdCircle(float radius, vec2 coord)
{
    return length(coord) - radius;
}

float sdBox(vec2 size, vec2 coord)
{
    vec2 d = abs(coord)-size/2.0;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

vec4 rgb(int r, int g, int b)
{
    vec3 rgb = vec3(r, g, b) / 255.0;
    return vec4(rgb, 1.0);
}

vec4 quad_mix(vec4 a, vec4 b, vec4 c, vec4 d, vec2 x)
{
    vec4 ta = mix(a, b, x.y);
    vec4 tb = mix(c, d, x.y);

    return mix(ta, tb, x.x);
}

float linear2D21D(vec2 x) 
{
    return (x.x + x.y) / 2.0;
}

float wtf2D21D(vec2 coord, float time) 
{
    float x = coord.x + coord.y;
    float multiplier = 0.0833333 * x*x + 0.0833333 * x;
    float angle = PI * multiplier;

    float sin1 = sin(DPI * (6.0 * sin(time) * 6.0 / PI) * angle + (PI / 2.0));

    return sin(angle) * sin1;
}

#define ARRAY_LENGTH 4
vec2 mix(in vec2 array[ARRAY_LENGTH], in float t) {
    float scaledT = t * float(ARRAY_LENGTH);
    int baseIndex = int(floor(scaledT));
    int nextIndex = (baseIndex + 1) % ARRAY_LENGTH;
    float floatingPart = fract(scaledT);

    return mix(array[baseIndex], array[nextIndex], floatingPart);
}

vec4 gradient(vec4 a, vec2 ap, vec4 b, vec2 bp, vec2 uv, float time) 
{
    // float t;
    // // t = linear2D21D(uv);
    // {
    //     float factor = 1.0;
    //     vec2 v = abs(uv - vec2(0));
    //     // t = dot(v, vec2(1.0)) / factor;
    //     t = length(v) / factor;
    // }
    // return mix(a, b, t);
    float length2ap = length(uv - ap);
    float length2bp = length(uv - bp);

    return mix(b, a * 0.5 / length2ap, length2bp);
}

float sstep(float bound, float g, float x)
{
    return step(bound, x);
}


vec2 apsectAwareUV(in vec2 uv, in vec2 resolution)
{
    float yPerX = resolution.y / resolution.x;
    float diff = (yPerX - 1.0) / 2.0;
    vec2 aspectedUV = uv;
    aspectedUV.y = mix(-diff, 1.0 + diff, aspectedUV.y);
    return aspectedUV;
}

vec2 oppositeUV(vec2 uv)
{
    vec2 center = vec2(0.5);
    vec2 dir = normalize(center - uv);
    float len = length(center - uv);
    return uv + dir * len * 2.0;
}

vec2 uv2coord(vec2 uv) 
{
    vec2 o = uv * 2.0 - 1.0;
    o.y *= -1.0;
    return o;
}

vec2 coord2uv(vec2 coord) 
{
    vec2 c = coord;
    c.y *= -1.0;
    return c * 0.5 + 0.5;
}

float dot1(vec2 vec) 
{
    return dot(vec, vec2(1.0));
}

vec3 hsb2rgb( in vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                             6.0)-3.0)-1.0,
                     0.0,
                     1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix( vec3(1.0), rgb, c.y);
}

float atan3(in float y, in float x) 
{
    float angle = atan(y, x);
    if (angle < 0.0) {
        angle += TWO_PI;
    }
    return angle;
}

float shape2d(vec2 xy, int type, float delta) 
{
    vec2 center = vec2(0);
    float hsize = 1.0 / 2.0;
    vec2 topLeft = center - hsize;
    vec2 botRight = center + hsize;
    switch (type) {
        case 0: {
            return dot1(step(topLeft, xy) - step(botRight, xy)) - 1.0;
        }
        case 1: {
            vec2 bounds = 1.0 - smoothstep(
                hsize - delta,
                hsize + delta, 
                abs(xy - center)
            );
            return bounds.x * bounds.y;
        }
        case 2: {
            vec2 sm1 = smoothstep(topLeft - delta, topLeft + delta, xy);
            vec2 sm2 = smoothstep(botRight - delta, botRight + delta, xy);
            return dot1(sm1 - sm2) - (distance(xy, center));
        }
        case 3: {
            return 1.0 - smoothstep(hsize - delta, hsize + delta, distance(xy, center));
        }
        case 4: {
            vec2 xyCoord = xy;
            float d;
            // d = length(abs(xyCoord) - 0.3);
            // d = length(min(abs(xyCoord) - 0.3, vec2(0.0)));
            d = length(max(abs(xyCoord) - 0.3, vec2(0.0)));
            
            float result;
            result = fract(iGlobalTime * d);
            result = step(pow(sin(iGlobalTime), 2.0), d);
            result = step(pow(0.54, 2.0), d) *
                     step(d, pow(0.63, 2.0));

            return result;
        }
        case 5: {
            vec2 fromCenter = xy - center;

            float radius = length(fromCenter);
            float angle = atan3(fromCenter.y, fromCenter.x);

            return 1.0 - smoothstep(
                hsize - delta,
                hsize + delta,
                radius + pow(sin(4.0 * angle), 1.0)
            );
        }
    }
}

float shape(float lb, float ub, float x, int type, float edge)
{
    float mid = lb + (ub - lb) / 2.0;
    switch (type) {
        case 0: {
            return step(lb, x) - step(ub, x);
        }
        case 1: {
            float lm = mix(lb, mid, edge);
            float um = mix(ub, mid, edge);
            return smoothstep(lb, lm, x) - smoothstep(um, ub, x);
        }
        case 2: {
            // return pow(cos(10.0 * x), 0.001);
            return cos(6.28 * x);
        }
        case 3: {
            return abs(x - mid);
        }
    }
}

mat3 translate(vec2 translation) {
    vec3 ix = vec3(1, 0, 0);
    vec3 iy = vec3(-ix.y, ix.x, 0);
    vec3 iz = vec3(-translation, 1.0);

    return mat3(ix, iy, iz);
}

mat3 scale(vec2 scale)
{
    vec3 ix = vec3(1, 0, 0);
    vec3 iy = vec3(-ix.y, ix.x, 0);
    vec3 iz = vec3(0, 0, 1);
    ix /= scale.x;
    iy /= scale.y;

    return mat3(ix, iy, iz);
}

mat3 rotate(float angle)
{
    vec3 ix = vec3(cos(angle), sin(angle), 0);
    vec3 iy = vec3(-ix.y, ix.x, 0);
    vec3 iz = vec3(0, 0, 1);

    return mat3(ix, iy, iz);
}

mat3 srt(vec2 scaleFactor, float angle, vec2 translation)
{
    mat3 rotateM = rotate(angle);
    mat3 translateM = translate(translation);
    mat3 scaleM = scale(scaleFactor);

    return scaleM * rotateM * translateM;
}

mat2 rotate2d(float angle)
{
    vec2 ix = vec2(cos(angle), sin(angle));
    vec2 iy = vec2(-ix.y, ix.x);
    
    return mat2(ix, iy) ;
}

vec2 sincos(vec2 xy)
{
    return vec2(sin(xy.x), cos(xy.y));
}

vec2 powv(vec2 xy, float pwr)
{
    return vec2(pow(xy.x, pwr), pow(xy.y, pwr));
}

float rand(vec2 xy)
{
    vec2 frequency = 2.0 * PI * vec2(15.1511, 42.5225);
    float amplitude = 12341.51611;
    return fract(sin(dot(xy, frequency)) * amplitude);
    // return fract(sin(xy.x * 100000.0 * 2.0 * PI) * 128.0);
}

float rand1 (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float rand3(vec3 xyz) {
    // vec3 frequency = 2.0 * PI * vec3(12.9898,78.233, 32.539);
    vec3 frequency = 2.0 * PI * vec3(1.5399,1.29123,1.39232);
    float amplitude = 12341.51611;
    return fract(sin(dot(xyz, frequency)) * amplitude);
}

vec2 rand2d(vec2 xy)
{
    const vec2 fr1 = vec2(127.1,311.7);
    const vec2 fr2 = vec2(269.5,183.3);
    const float amp = 43758.5453123;

    xy = vec2(dot(xy, fr1), dot(xy, fr2));
    return fract(sin(xy) * amp) * 2.0 - 1.0;
}

vec3 rand3d(vec3 xyz)
{
    const vec3 fr1 = vec3(127.134,311.732,854.129);
    const vec3 fr2 = vec3(269.532,183.343,381.482);
    const vec3 fr3 = vec3(438.453, 593.548,123.583);
    const float amp = 43758.5453123;

    xyz = vec3(dot(xyz, fr1), dot(xyz, fr2), dot(xyz, fr3));
    return fract(sin(xyz) * amp) * 2.0 - 1.0;
}

float discreted(float value, float factor)
{
    return round(value * factor) / factor;
}

float line(vec2 uv)
{
    float value;

    float thikness = 0.1;
    float m = 0.5;
    float m1 = m - thikness / 2.0;
    float m2 = m + thikness / 2.0;
    float d = 0.1;
    value = smoothstep(m1 - d, m1, uv.y);
    value -= smoothstep(m2, m2 + d, uv.y);

    return 1.0 - value;
}
