uniform sampler2D sampler_texture;

// uniform vec3 light_pos; // 
uniform float ka; 
uniform float kd; 
uniform float ks; 
uniform float ns; 

uniform vec3 view_pos;

vec3 base_light = vec3(1.0, 1.0, 1.0);

#define MAX_LIGHTS 10
uniform vec3 lights_position[MAX_LIGHTS];
uniform vec3 lights_color[MAX_LIGHTS];
uniform float lights_intensity[MAX_LIGHTS];
uniform float lights_reach[MAX_LIGHTS];
uniform int index_max;

// Luz que acompanha a camera
uniform vec3 camera_color;
uniform float camera_intensity;
uniform float camera_reach;

varying vec3 out_position; // recebido do vertex shader
varying vec2 out_texture;
varying vec3 out_normal; // recebido do vertex shader


vec3 phong(vec3 position, vec3 color, float reach, float intensity);

void main(){
    vec3 ambient = ka * base_light;             

    vec3 sum = ambient; // aplica iluminacao

    for (int i = 0; i < index_max; i++) {
        sum += phong(
            lights_position[i], 
            lights_color[i], 
            lights_reach[i],
            lights_intensity[i]
        );
    }

    sum += phong(view_pos, camera_color, camera_reach, camera_intensity);
    
    vec4 texture = texture2D(sampler_texture, out_texture);
    vec4 result = vec4(sum, 1.0) * texture; // aplica iluminacao
    gl_FragColor = result;
}

vec3 phong(vec3 position, vec3 color, float reach, float intensity) {
    vec3 N = normalize(out_normal); 
    vec3 L = normalize(position - out_position); // direcao da luz
    float diff = max(dot(N, L), 0.0); // verifica limite angular (entre 0 e 90)

    float dist = distance(position, out_position);
    float fading = max((pow(reach - dist, 2.0) / pow(reach, 2.0)) * intensity, 0.0);

    vec3 diffuse = kd * diff * fading * color; // iluminacao difusa

    vec3 V = normalize(view_pos - out_position); // direcao do observador/camera
    vec3 R = reflect(-L, N); // direcao da reflexao

    float spec = pow(max(dot(V, R), 0.0), ns);
    
    vec3 specular = ks * spec * fading * color;

    return diffuse + specular;
}