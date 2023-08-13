#include "base_noise.glsl"

void main()
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;
    vec2 awUV = apsectAwareUV(uv, iResolution.xy);
    vec2 coord = uv2coord(uv);

    int type;
    // type = nearestNeighbor;
    // type = linear;
    // type = cubic;
    type = quintic;

    float noise;
    // 1D noise smoothing
    // noise = noise1d(uv.x + iGlobalTime * 10.0, type);
    noise = noise2d(2.0 * uv + iGlobalTime, type);

    vec2 delta = 1.0 / iResolution.xy;
    vec2 position = vec2(0.0);
    mat3 m = translate(position);

    vec3 color;
    // {
    //     vec2 speed = gradient(uv, delta);

    //     vec3 noise3 = vec3(noise);
    //     vec3 speed3 = vec3(speed, 0);
    //     vec3 speedMagnitude = vec3(length(speed3));

    //     color = noise3;
    // }
    // {
    //     float fraction = makeFraction(vec3(iGlobalTime), 3).x;
    //     color = vec3(between2noises(uv, type, fraction));
    // }

    // {
    //     float sd = noise2d(16.0 * uv, cubic);
    //     float m = pow(sin(iGlobalTime), 2.0);
    //     float d = 0.01;
    //     float value = smoothstep(m - d, m + d, sd);

    //     color = vec3(value);
    // }

    // {
    //     float sd = between2noises(4.0 * uv, type, fract(iGlobalTime));

    //     float m = sin(iGlobalTime * 0.1) * sin(iGlobalTime * 1.5);
    //     m = pow(m, 2.0);
    //     m = 0.5;
    //     float d = 0.1;
    //     float value = smoothstep(m - d, m + d, sd);

    //     color = mix(vec3(2, 0, 0), vec3(0, 0, 2), value);
    // }

    // {
    //     float noise = between2noises(4.0 * uv, cubic, fract(iGlobalTime)) * 2.0;

    //     vec3 r = vec3(2, 0, 0);
    //     vec3 g = vec3(0, 2, 0);
    //     vec3 b = vec3(0, 0, 2);

    //     float t1 = saturate(noise);
    //     float t2 = noise - saturate(noise);
    //     color = mix(mix(r, g, t1), b, t2);
    // }

    // {
    //     float t = fract(iGlobalTime);
    //     float noise1 = between2noises(4.0 * uv, cubic, t);
    //     float noise2 = between2noises(4.0 * uv + vec2(213.82, -381.31), cubic, t);
    //     float noise3 = between2noises(4.0 * uv + vec2(-319.83, 9.8521), cubic, t);

    //     vec3 value = vec3(noise1, noise2, noise3);
    //     float m = 0.5;
    //     float d = 0.01;

    //     color = smoothstep(m - d, m + d, value);
    // }

    {
        float noise = noise2d(16.0 * uv + iGlobalTime, type);
        float radius;
        {
            radius = noise;
        }
        // {
        //     vec2 radiusVector = normalize(uv - 0.5);
        //     float radiusMagnitude = sin(iGlobalTime / 4.0) * 4.0;
        //     vec2 noisePosition = 0.5 + radiusVector * radiusMagnitude;
        //     float noise = noise2d(noisePosition, type);
        //     radius = noise;
        // }

        float d = 0.01;
        float signedDistance;
        signedDistance = sdCircle(0.5 + (noise * 2.0 - 1.0) * 0.1, (m * vec3(uv2coord(awUV), 1)).xy);
        // signedDistance = sdBox(vec2(radius), (m * vec3(uv2coord(awUV), 1)).xy);
        float value = smoothstep(+d, -d, signedDistance);

        color = vec3(value);
    }

    // {
    //     vec2 grad = 1.0 * gradient(4.0 * uv + iGlobalTime, delta);
    //     float d = 0.01;
    //     float sd = sdBox(grad, (m * vec3(uv2coord(awUV), 1)).xy);
    //     float isBox = smoothstep(+d, -d, sd);

    //     color = vec3(isBox);
    // }

    gl_FragColor = vec4(color, 1);
}
