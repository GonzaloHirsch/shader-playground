// cosine based palette, 4 vec3 params
vec3 wrapped_palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}

vec3 pallete(in float t) {
    return wrapped_palette(t, vec3(0.278, 0.098, 0.998), vec3(1.165, 0.405, 0.331), vec3(1.460, 1.460, 2.991), vec3(0.498, 1.298, 0.667));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    // iResolution comes as a global constant
    // Center the origin (0,0) to the center of the screen
    // Scaling the coordinates to have the center at (0,0) and have the bounds at (-1, 1)
    // Ensure this works even when it's stretched
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    
    // Keep track of original UV.
    vec2 uv0 = uv;
    
    vec3 finalColor = vec3(0.0);
    
    for (float i = 0.0; i < 4.0; i++) {
        // Repeat in space, brekaing symmetry with a decimal factor
        uv = fract(uv * 1.4) - 0.5;

        // Distance from the uv vector to the center. Works because it's centered in (0,0)
        float d = length(uv) * exp(-length(uv0));

        // Generate the color with an offset
        // Add a reduction in time for the speed.
        vec3 col = pallete(length(uv0) + i * 0.3 + iTime * 0.3);

        // Add a factor the the sine to scale the number of circles.
        // Add time to have it moving.
        float factor = 8.;
        d = sin(d * factor + iTime) / factor;
        d = abs(d);

        // Gives it a neon aesthetic because the 1/x goes to infinity very quickly.
        // By using the power it increases the contrast
        d = pow(0.01 / d, 2.0);

        finalColor += (col * d);
    }
    

    // Output to screen
    fragColor = vec4(finalColor, 1.0);
}