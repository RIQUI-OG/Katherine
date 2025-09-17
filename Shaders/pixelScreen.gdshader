shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 64.0) = 4.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 screen_uv = SCREEN_UV;

    // Reduce precisión para pixelado
    screen_uv = floor(screen_uv * vec2(textureSize(SCREEN_TEXTURE, 0)) / pixel_size) * pixel_size / vec2(textureSize(SCREEN_TEXTURE, 0));

    COLOR = texture(SCREEN_TEXTURE, screen_uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
