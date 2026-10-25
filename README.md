Showcase of burning some vertices over time
with [ArrayMesh](https://docs.godotengine.org/en/stable/classes/class_arraymesh.html#class-arraymesh)
and the [CUSTOM0](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html#vertex-built-ins) vertex built-in.

<video controls autoplay loop src="https://github.com/user-attachments/assets/50beba79-3ff7-4783-8d06-535bbe357c9c">
    <source src="https://github.com/user-attachments/assets/50beba79-3ff7-4783-8d06-535bbe357c9c" type="video/mp4" />
</video>

The maths aren't quite correct right now.

There's also the alternative of painting a mask texture that's read by a shader to mix between "raw meat" and "cooked/burnt meat" instead of "vertex painting" unto custom vertex attributes like I'm doing right now, but there's some techincal hoops that I'm yet to figure out, like:

- Would the fragment shader "paint" to the mask based on exposure and then we'd read that buffer between frames?
  Is that even possible in Godot?
- Could we "raycast" from the fire to the exposed surface and map that to the texel coordinates of the mask to paint the thing correctly?
- what would be the constraints of the UV unwrapping for the chicken?
