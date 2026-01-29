shader_type spatial;

uniform float scroll_speed = 1.0;
uniform vec2 scroll_direction = vec2(0.0, 1.0); // New: Control which way it slides
uniform vec2 tex_scale = vec2(1.0, 1.0);
uniform sampler2D belt_texture : source_color, repeat_enable;

void fragment() {
    // Multiply speed by direction and time
    vec2 offset = scroll_direction * scroll_speed * TIME;
    vec2 shifted_uv = (UV * tex_scale) + offset;
    
    ALBEDO = texture(belt_texture, shifted_uv).rgb;
}