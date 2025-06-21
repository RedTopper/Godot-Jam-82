shader_type canvas_item;

uniform sampler2D normal_map : hint_normal;
uniform float specular_intensity = 2.0;
uniform float shininess = 64.0;
uniform float ambient_light = 0.1;
uniform vec2 viewport_size;

void fragment() {
    vec4 albedo = texture(TEXTURE, UV);
    vec3 normal = texture(normal_map, UV).rgb;
    normal = normalize(normal * 2.0 - 1.0);

    vec2 light_pos = SCREEN_UV * viewport_size;
    vec2 frag_pos = FRAGCOORD.xy;
    vec2 light_dir_2d = normalize(light_pos - frag_pos);
    vec3 light_dir = normalize(vec3(light_dir_2d, 1.0));

    vec3 view_dir = vec3(0.0, 0.0, 1.0);
    vec3 reflect_dir = reflect(-light_dir, normal);

    float diff = max(dot(normal, light_dir), 0.0);
    vec3 half_dir = normalize(light_dir + view_dir);
    float spec = pow(max(dot(normal, half_dir), 0.0), shininess) * 0.5;

    float fresnel = pow(1.0 - max(dot(view_dir, normal), 0.0), 3.0);


    vec3 diffuse = albedo.rgb * (diff + ambient_light);
    vec3 specular = vec3(specular_intensity) * spec * fresnel;

    COLOR = vec4(diffuse + specular, albedo.a);
}

