#include<flutter/runtime_effect.glsl>

#define M_PI 3.1415926535897932384626433832795

const int numX=4;
const int numY=3;

uniform vec2 resolution;
uniform vec3 colors[numX*numY];
out vec4 fragColor;

vec3 linearTosRGB(vec3 linear){
  vec3 upper=vec3(1.055)*pow(linear,vec3(1./2.4))-vec3(.055);
  vec3 lower=linear*vec3(12.92);
  bvec3 threshold=lessThan(linear,vec3(.003131));
  return lower*vec3(threshold)+upper*vec3(not(threshold));
}

vec4 blurHash(vec2 uv){
  vec3 linear=vec3(0);
  for(int j=0;j<numY;j++){
    float basisY=cos(M_PI*uv.y*float(j));
    for(int i=0;i<numX;i++){
      float basis=cos(M_PI*uv.x*float(i))*basisY;
      vec3 color=colors[i+j*numX];
      linear+=color*basis;
    }
  }
  return vec4(linearTosRGB(linear),1.);
}

void main(){
  vec2 uv=FlutterFragCoord().xy/resolution.xy;
  fragColor=blurHash(uv);
}
