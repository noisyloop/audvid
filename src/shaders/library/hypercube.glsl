// name: HYPERCUBE
// category: 3d
// ported from prism-video-synth
float line3(vec3 p,vec3 a,vec3 b){vec3 pa=p-a,ba=b-a;float h=clamp(dot(pa,ba)/dot(ba,ba),0.0,1.0);return length(pa-ba*h)-0.015;}
vec3 proj4(vec4 v,float w){return v.xyz/(v.w+w);}
mat4 rot4XW(float a){float c=cos(a),s=sin(a);return mat4(c,0,0,-s,0,1,0,0,0,0,1,0,s,0,0,c);}
mat4 rot4YZ(float a){float c=cos(a),s=sin(a);return mat4(1,0,0,0,0,c,-s,0,0,s,c,0,0,0,0,1);}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed*0.4;
  mat4 r1=rot4XW(t*0.7);mat4 r2=rot4YZ(t*0.5);
  vec4 verts[16];
  for(int i=0;i<16;i++){
    float fi=float(i);
    float x=mod(fi,2.0)*2.0-1.0,y=mod(floor(fi/2.0),2.0)*2.0-1.0,z=mod(floor(fi/4.0),2.0)*2.0-1.0,w=mod(floor(fi/8.0),2.0)*2.0-1.0;
    vec4 v=r2*r1*vec4(x,y,z,w)*0.5*u_scale;
    verts[i]=v;
  }
  float d=1e9;
  for(int a=0;a<16;a++)for(int b=0;b<16;b++){
    if(b>a){
      float fa=float(a),fb=float(b);
      float dx=abs(mod(fa,2.0)-mod(fb,2.0));
      float dy=abs(mod(floor(fa/2.0),2.0)-mod(floor(fb/2.0),2.0));
      float dz=abs(mod(floor(fa/4.0),2.0)-mod(floor(fb/4.0),2.0));
      float dw=abs(mod(floor(fa/8.0),2.0)-mod(floor(fb/8.0),2.0));
      if(dx+dy+dz+dw<1.5){
        vec3 pa=proj4(verts[a],2.5);
        vec3 pb=proj4(verts[b],2.5);
        float ld=line3(vec3(uv,0.0),pa,pb);
        d=min(d,ld);
      }
    }
  }
  float v=smoothstep(0.04,0.0,d);
  float hue=d*2.0+t*0.2;
  vec3 col=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*v;
  col+=vec3(0.05,0.0,0.1)*(1.0-v);
  outColor=vec4(col*u_intensity,1.0);}
