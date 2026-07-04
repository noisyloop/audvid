// name: SIERPINSKI 3D
// category: 3d
// ported from prism-video-synth
float tetra(vec3 p){
  p/=u_scale;
  const int IT=8;
  float s=1.0;
  for(int i=0;i<8;i++){
    if(p.x+p.y<0.0){float t2=p.x;p.x=-p.y;p.y=-t2;}
    if(p.x+p.z<0.0){float t2=p.x;p.x=-p.z;p.z=-t2;}
    if(p.y+p.z<0.0){float t2=p.z;p.z=-p.y;p.y=-t2;}
    p=p*2.0-vec3(1.0);s*=2.0;
  }
  return length(p)/s*u_scale;
}
mat3 rotY(float a){float c=cos(a),s=sin(a);return mat3(c,0,s,0,1,0,-s,0,c);}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed*0.25;
  vec3 ro=rotY(t)*(vec3(0,0,3.5));
  vec3 rd=normalize(rotY(t)*vec3(uv,-1.5));
  float d=0.0;vec3 p=ro;bool hit=false;
  for(int i=0;i<120;i++){float s=tetra(p);if(s<0.003){hit=true;break;}d+=max(s,0.005);p=ro+rd*d;if(d>12.0)break;}
  vec3 col=vec3(0.0);
  if(hit){
    float eps=0.005;
    vec3 n=normalize(vec3(tetra(p+vec3(eps,0,0))-tetra(p-vec3(eps,0,0)),tetra(p+vec3(0,eps,0))-tetra(p-vec3(0,eps,0)),tetra(p+vec3(0,0,eps))-tetra(p-vec3(0,0,eps))));
    float diff=max(dot(n,normalize(vec3(1,2,1))),0.0)*0.8+0.2;
    float hue=p.x*0.3+p.y*0.4+t*0.15;
    col=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*diff;
    col+=vec3(0.5,0.2,1.0)*pow(1.0-diff,3.0);
  }else{col=vec3(0.02,0.01,0.04);}
  outColor=vec4(audioPop(col*u_intensity),1.0);}
