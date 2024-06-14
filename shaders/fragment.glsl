uniform vec4 color;
uniform sampler2D samplerTexture;

uniform vec3 lightPos; // define coordenadas de posicao da luz
uniform float ka; // coeficiente de reflexao ambiente
uniform float kd; // coeficiente de reflexao difusa

vec3 lightColor = vec3(1.0, 1.0, 1.0);

varying vec3 out_fragPos; // recebido do vertex shader
varying vec2 out_texture;
varying vec3 out_normal; // recebido do vertex shader

void main(){
    vec4 texture = texture2D(samplerTexture, out_texture);
    gl_FragColor = texture;
}