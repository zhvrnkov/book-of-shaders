#include "base.glsl"

float sigmoid(float x)
{
    return 1.0 / (1.0 + exp(-x));
}

vec2 sigmoid(vec2 x)
{
    return vec2(sigmoid(x.x), sigmoid(x.y));
}

void neuronVisualization() 
{
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    // uv = apsectAwareUV(uv, iResolution.xy);
    float factor = 1.0;
    uv = uv * factor - (factor - 1.0) / 2.0;

    vec2 W;
    float B; 
    // or
    // {
    //     W = vec2(7.94299746, 7.94299793);
    //     B = -3.78545237;
    // }

    // and
    {
        W = vec2(7.94299746, 7.94299793);
        B = -3.78545237;
    }

    float evaluation = dot(W, uv) + B;
    evaluation = W.x * uv.x + B / 2.0;
    // evaluation += W.y * uv.y + B / 2.0;
    evaluation = dot(vec3(uv, 0.3), vec3(1.0));
    evaluation = sigmoid(evaluation);

    vec3 color;
    color = vec3(length(uv) / sqrt(2.0));
    color = vec3(evaluation);
    gl_FragColor = vec4(color, 1);
}

void networkVisualization() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    // uv = apsectAwareUV(uv, iResolution.xy);
    float factor = 1.2;
    uv = uv * factor - (factor - 1.0) / 2.0;

    // working ws and bs
    mat2x2 w1 = mat2x2(4.59, 4.56, 6.62, 6.46);
    vec2 b1 = vec2(-7.29, -2.87);

    vec2 w2 = vec2(-10.36, 9.37);
    float b2 = -4.47;

    // flat ws and bs
    // mat2x2 w1 = mat2x2(3.17, 3.16, 4.20, 4.21) + iGlobalTime;
    // vec2 b1 = vec2(0.29, -0.5);

    // vec2 w2 = vec2(1.42, 3.04);
    // float b2 = -3.804;

    vec2 inp = uv;
    vec2 a1 = sigmoid(w1 * inp + b1);
    float a2 = sigmoid(dot(w2, a1) + b2);
    float evaluation= a2;
    
    vec3 color;
    color = vec3(evaluation);
    gl_FragColor = vec4(color, 1);
}

void main() {
    networkVisualization();
}