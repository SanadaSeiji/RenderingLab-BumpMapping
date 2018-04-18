
#version 410
//codes following
//https://github.com/capnramses/antons_opengl_tutorials_book/tree/master/20_normal_mapping
//https://learnopengl.com/Advanced-Lighting/Normal-Mapping

// inputs: texture coordinates, and view and light directions in tangent space
in vec2 st;
in vec3 view_dir_tan;
in vec3 light_dir_tan;

// the normal map texture
uniform sampler2D normal_map;
//uniform sampler2D tex;
uniform float bumpDegree;

// output colour
out vec4 frag_colour;

in vec4 test_tan;

void main() {
    
	 //color from texture
       //vec4 texel = texture (tex, st);
       //vec3 texC = texel.xyz;
    
	vec3 Ia = vec3 (0.2, 0.2, 0.2);
	
	// sample the normal map and covert from 0:1 range to -1:1 range
	vec3 normal_tan = texture (normal_map, st).rgb;
	//manipulate magititude of normal_tan, change how clear the bump is, range [0-1]
	
	//bump "grows" out
	// keep bd == 1.0, no growing effect
	float bd = bumpDegree *0.005 < 1.0? bumpDegree * 0.005 : 1.0;
	normal_tan = vec3 ( bd* normal_tan.x,  bd* normal_tan.y,  bd * normal_tan.z);
	normal_tan = normalize (normal_tan * 2.0 - 1.0); // [0, 1] to [-1, 1]
	
	

	// diffuse light equation done in tangent space
	vec3 direction_to_light_tan = normalize (-light_dir_tan);
	float dot_prod = dot (direction_to_light_tan, normal_tan);
	dot_prod = max (dot_prod, 0.0);
	vec3 Id = vec3 (0.5, 0.5, 0.5) * vec3 (0.5, 0.5, 0.5)  * dot_prod;

	// specular light equation done in tangent space
	vec3 reflection_tan = reflect (normalize (light_dir_tan), normal_tan);
	float dot_prod_specular = dot (reflection_tan, normalize (view_dir_tan));
	dot_prod_specular = max (dot_prod_specular, 0.0);
	float specular_factor = pow (dot_prod_specular, 100.0);
	vec3 Is = vec3 (1.0, 1.0, 1.0) * vec3 (0.5, 0.5, 0.5)  * specular_factor;

	// phong light output
	frag_colour.rgb = Is + Id + Ia;
	frag_colour.a = 1.0;
}