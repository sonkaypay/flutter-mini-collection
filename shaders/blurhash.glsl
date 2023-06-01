#include<flutter/runtime_effect.glsl>

#define M_PI 3.1415926535897932384626433832795
#define MAX_ITERATIONS 10.

uniform sampler2D colors;
uniform float numX;
uniform float numY;
uniform vec2 resolution;
out vec4 fragColor;

vec3 linearTosRGB(vec3 linear){
  vec3 upper=vec3(1.055)*pow(linear,vec3(1./2.4))-vec3(.055);
  vec3 lower=linear*vec3(12.92);
  bvec3 threshold=lessThan(linear,vec3(.003131));
  return lower*vec3(threshold)+upper*vec3(not(threshold));
}

vec4 blurHash(vec2 uv){
  vec3 linear=vec3(0);
  for(float j=0.;j<MAX_ITERATIONS;j+=1.){
    if(j>=numY)break;
    float basisY=cos(M_PI*uv.y*j);
    for(float i=0.;i<MAX_ITERATIONS;i+=1.){
      if(i>=numX)break;
      float basis=cos(M_PI*uv.x*i)*basisY;
      vec3 color=texture(colors,ivec2(int(i),int(j))).rgb;
      linear+=color*basis;
    }
  }
  return vec4(linearTosRGB(linear),1.);
}

void main(){
  vec2 uv=FlutterFragCoord().xy/resolution;
  fragColor=blurHash(uv);
}
