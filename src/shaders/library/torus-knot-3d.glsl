// name: TORUS KNOT 3D
// category: 3d
// ported from prism-video-synth
float sdTorus(vec3 p,vec2 t){vec2 q=vec2(length(p.xz)-t.x,p.y);return length(q)-t.y;}
mat3 rotY(float a){float c=cos(a),s=sin(a);return mat3(c,0,s,0,1,0,-s,0,c);}
mat3 rotX(float a){float c=cos(a),s=sin(a);return mat3(1,0,0,0,c,-s,0,s,c);}
float map(vec3 p,float t){
  float P=2.0,Q=3.0;
  float phi=atan(p.z,p.x);
  float r=length(p.xz);
  float theta=atan(p.y,r-1.0*u_scale);
  float knotPhi=P*phi-Q*theta;
  vec3 kp=vec3(cos(knotPhi)*(1.0+0.35*cos(P*phi)),0.35*sin(P*phi),sin(knotPhi)*(1.0+0.35*cos(P*phi)));
  return length(p-kp*u_scale*0.4)-0.08*u_scale;
}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed;
  vec3 ro=vec3(0.0,0.0,3.5);
  vec3 rd=normalize(vec3(uv,-1.5));
  mat3 ry=rotY(t*0.4);mat3 rx=rotX(t*0.25);
  ro=ry*rx*ro;rd=ry*rx*rd;
  float d=0.0;vec3 p=ro;float hit=0.0;
  for(int i=0;i<80;i++){float s=map(p,t);if(s<0.002){hit=1.0;break;}d+=s;p=ro+rd*d;if(d>10.0)break;}
  vec3 col=vec3(0.0);
  if(hit>0.5){
    float eps=0.002;
    vec3 n=normalize(vec3(map(p+vec3(eps,0,0),t)-map(p-vec3(eps,0,0),t),map(p+vec3(0,eps,0),t)-map(p-vec3(0,eps,0),t),map(p+vec3(0,0,eps),t)-map(p-vec3(0,0,eps),t)));
    vec3 ld=normalize(vec3(1,2,1));
    float diff=max(dot(n,ld),0.0);
    float spec=pow(max(dot(reflect(-ld,n),normalize(ro-p)),0.0),32.0);
    float hue=d*0.15+t*0.2+p.y*0.5;
    col=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*(diff*0.8+0.2)+vec3(1.0)*spec*0.5;
    col+=vec3(0.3,0.1,0.8)*pow(1.0-diff,3.0);
  }else{col=vec3(0.02,0.0,0.05)+vec3(0.1,0.0,0.2)*length(uv);}
  outColor=vec4(col*u_intensity,1.0);}
