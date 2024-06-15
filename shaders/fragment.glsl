uniform sampler2D samplerTexture;

// uniform vec3 lightPos; // define coordenadas de posicao da luz
uniform float ka; // coeficiente de reflexao ambiente
uniform float kd; // coeficiente de reflexao difusa
uniform float ks; // coeficiente de reflexao difusa
uniform float ns; // coeficiente de reflexao difusa
uniform vec3 viewPos;

vec3 baseLight = vec3(1.0, 1.0, 1.0);
// vec3 lightColor = vec3(1.0, 1.0, 1.0);

#define MAX_LIGHTS 10
uniform vec3 lights_position[MAX_LIGHTS];
uniform vec3 lights_color[MAX_LIGHTS];
uniform float lights_intensity[MAX_LIGHTS];
uniform float lights_reach[MAX_LIGHTS];
uniform int index_max;

varying vec3 out_fragPos; // recebido do vertex shader
varying vec2 out_texture;
varying vec3 out_normal; // recebido do vertex shader

void main(){
    vec3 ambient = ka * baseLight;             

    vec3 sum = ambient; // aplica iluminacao

    for (int i = 0; i < index_max; i++) {
        vec3 lightPos = lights_position[i];
        vec3 lightColor = lights_color[i];

        vec3 norm = normalize(out_normal); // normaliza vetores perpendiculares
        vec3 lightDir = normalize(lightPos - out_fragPos); // direcao da luz
        float diff = max(dot(norm, lightDir), 0.0); // verifica limite angular (entre 0 e 90)

        float fading = max((10.0 - distance(lightPos, out_fragPos)), 0.0);

        vec3 diffuse = kd * diff * fading * lightColor; // iluminacao difusa
    
        vec3 viewDir = normalize(viewPos - out_fragPos); // direcao do observador/camera
        vec3 reflectDir = reflect(-lightDir, norm); // direcao da reflexao

        float spec = pow(max(dot(viewDir, reflectDir), 0.0), ns);
        
        vec3 specular = ks * spec * lightColor;

        sum += diffuse + specular;
    }

    
    vec4 texture = texture2D(samplerTexture, out_texture);
    vec4 result = vec4(sum, 1.0) * texture; // aplica iluminacao
    gl_FragColor = result;
}