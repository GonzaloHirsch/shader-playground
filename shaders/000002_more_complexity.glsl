// cosine based palette, 4 vec3 params
vec3 wrapped_palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}

vec3 pallete(in float t) {
    return wrapped_palette(t, 
        vec3(0.610,0.498,0.650), 
        vec3(0.388,0.498,0.350), 
        vec3(0.448,0.498,0.620), 
        vec3(2.558,3.012,4.025)
    );
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    // iResolution comes as a global constant
    // Center the origin (0,0) to the center of the screen
    // Scaling the coordinates to have the center at (0,0) and have the bounds at (-1, 1)
    // Ensure this works even when it's stretched
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    
    vec3 finalColor = vec3(0.0);
    float speed = 0.5;
    
    float prev = 0.0;
    for (float i = 1.0; i < 5.0; i++) {
        // Make multiple versions
        uv = fract(uv * 1.0) - 0.5;
        // First iteration of function
        float d = -sqrt(prev * i / 2.0) + pow(length(uv), 2.0) * (sin(iTime * sqrt(i) * speed) + 1.25);
        // Add more contrast to it
        d = pow(0.01/(d * i), 2.0);
        // Add color
        vec3 color = pallete(d);
        // Store previous one
        prev = d;
        finalColor += color * d;
    }
    
    // Output to screen
    fragColor = vec4(finalColor, 1.0);
}