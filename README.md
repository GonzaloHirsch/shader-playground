# shader-playground

This repository contains a playground for writing shaders in GLSL and guidance on some of the basics.

---

- [Resources](#resources)
- [Basics](#basics)
  - [Overview](#overview)
  - [Basic Principles for All Shaders](#basic-principles-for-all-shaders)
  - [Palletes](#palletes)
- [Rendering Locally](#rendering-locally)
- [Workflows](#workflows)

---

## Resources

These are some general resources that might help you start working with shaders:

- [Shadertoy](https://www.shadertoy.com/new) --> You can try shaders online in a browser-based environment.
- [Distfunctions2d](https://iquilezles.org/articles/distfunctions2d/) --> Collection of 2D signed distance functions for different shapes.
- [Color Palletes](https://iquilezles.org/articles/palettes/) --> Build a function for your color palletes.
- [Pallete Builder](http://dev.thi.ng/gradients/) --> Helps you build your pallete parameters.
- [Math functions](https://registry.khronos.org/OpenGL-Refpages/gl4/index.php) --> All the built-in functions.

## Basics

These are some notions helpful to understand shaders and some of the common principles of using them.

### Overview

Shaders compute the value of a unique pixel in parallel. Each thread will compute the value of the given pixel, and the function looks like this:

```
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Output to screen
    fragColor = vec4(...);
}
```

Note that in 2D the `fragCoord` vector has the (x,y) coordinates of the pixel, while `fragColor` has the output color in (r,g,b,a) format.

### Basic Principles for All Shaders

These are some basic transformations that you need (or should) apply each time you have a shader to ensure it works correctly.

```
// 1. Normalize the space in between (0,1)
vec2 uv = fragCoord / iResolution.xy;

// 2. Center the canvas origin to (0,0) but bounds are in (-0.5,0.5)
uv = uv - 0.5;

// 3. Ensure the center is in (0,0) but the bounds are in (-1,1)
uv = uv * 2.0;

// 4. Simplifying #2 and #3 in one
uv = (uv * 2.0) - 1.0;

// 5. Simplifying #4 and #1 in one
vec2 uv = fragCoord / iResolution.xy * 2.0 - 1.0;

// 6. Ensure it works even when stretched
uv.x *= iResolution.x / iResolution.y;

// 7. Simplify #6 and #5 in one
vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
```

Some available globals:

- `iTime` --> Number of seconds elapsed from shader start.

### Palletes

It's great to have a pallete and dynamic colors. For this you can use a pallete function based on trigonometry:

```
// cosine based palette, 4 vec3 params
vec3 palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}
```

To simply the use of the pallete, you can do something like:

```
// cosine based palette, 4 vec3 params
vec3 w_palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}

vec3 pallete(in float t) {
    return w_pallete(t, vec3(0.278, 0.098, 0.998), vec3(1.165, 0.405, 0.331), vec3(1.460, 1.460, 2.991), vec3(0.498, 1.298, 0.667));
}
```

## Rendering Locally

Since it might be useful to render the shader locally (more ideas for that in the future), this section tackles doing so. To do this,

```
git clone https://github.com/danilw/shadertoy-to-video-with-FBO.git --depth 1
python3 shadertoy-to-video/shadertoy-render.py --output example.mp4 --size=800x800 --rate=60 --bitrate=5M --duration=30.0 shaders/000001_intro.glsl
```

## Workflows

This repository contains workflows to simplify the publication process for any video or content on Instagram to minimise effort. To do so, it needs the following environment secrets:

- `EMAIL_FROM` --> Address from where emails come from.
- `EMAIL_TO` --> Address where emails are going to.
- `IG_ACCOUNT` --> Name of the IG account for the emails.

export EMAIL_FROM="me@gonzalohirsch.com" && export EMAIL_TO="hirschgonzalo@gmail.com" && export IG_ACCOUNT="TestAccount" && export MIME="video/mp4" && export FILENAME="example.mp4" && export REGION="us-east-1" && ./5_email_notification.sh

aws ses send-email --to hirschgonzalo@gmail.com --from me@gonzalohirsch.com --subject "Testing Emails" --text "Hello there! How are you?" --html 'Hello there!<br><br>How are you?'

echo '{"Data": "From: ${{secrets.EMAIL_FROM}}\nTo: ${{secrets.EMAIL_TO}}\nSubject: [${{secrets.IG_ACCOUNT}}] New Post \nMIME-Version: 1.0\nContent-type: Multipart/Mixed; boundary=\"NextPart\"\n\n--NextPart\nContent-Type: text/plain\n\n[Body]\n\n--NextPart\nContent-Type: ${{env.MIME}};\nContent-Disposition: attachment;\nContent-Transfer-Encoding: base64; filename=\"${{env.FILENAME}}\"\n\n'$(base64 ${{env.FILENAME}})'\n--NextPart--"}' > message.json & aws ses send-raw-email --region eu-west-1 --raw-message ./message.json
