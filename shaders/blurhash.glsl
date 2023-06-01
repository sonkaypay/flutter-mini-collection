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
  vec2 uv=FlutterFragCoord().xy/resolution;
  fragColor=blurHash(uv);
}

// some changes are needed to run this shader on WebGL (e.g. https://glslsandbox.com)
/*

precision highp float;

void mainWebGL(){
  colors[0]=vec3(.25415209433082675,.2232279573168085,.1946178304415758);
  colors[1]=vec3(.054691275287536055,.04050427626171068,.022311468094600627);
  colors[2]=vec3(.03153792895989249,.07144614159933095,.07228915662650602);
  colors[3]=vec3(-.019420388322643853,-.006180462076066673,-.0035698348951360994);
  colors[4]=vec3(-.041610945349748595,-.029372027970299162,-.014279339580544398);
  colors[5]=vec3(-.00010192797511376846,.011431382655892807,.0035698348951360994);
  colors[6]=vec3(-.020401181429053016,-.02092457240473123,-.0321285140562249);
  colors[7]=vec3(-.020377548437779325,-.020472162580763138,-.022311468094600627);
  colors[8]=vec3(-.05469127528753607,-.029372027970299162,-.014279339580544398);
  colors[9]=vec3(-.030373194345047722,-.030459789295686924,-.0321285140562249);
  colors[10]=vec3(.010546717135258512,-.0004177992363420948,-.008032128514056224);
  colors[11]=vec3(.04093845629061316,.02883556386209649,.014279339580544398);
  
  vec2 uv=gl_FragCoord.xy/resolution;
  gl_FragColor=blurHash(uv);
}
*/
