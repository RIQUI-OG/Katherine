shader_type canvas_item;

uniform float time : hint_range(0.0, 100.0);
uniform float drop_speed = 1.0;
uniform float drop_size = 0.05;
uniform float drop_density = 30.0;
uniform float distortion_strength = 0.01;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = UV;

    float t = TIME * drop_speed;
    float rain = 0.0;

    for (int i = 0; i < int(drop_density); i++) {
        float xi = float(i) / drop_density;
        float yi = fract(xi * 57.0);
        vec2 pos = vec2(xi, fract(yi + t));

        float dist = distance(uv, pos);
        rain += smoothstep(drop_size, 0.0, dist);
    }

    vec2 offset = vec2(0.0, rain * distortion_strength);
    COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + offset);
}
