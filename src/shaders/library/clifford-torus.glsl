// name: CLIFFORD TORUS
// category: 3d
// ported from prism-video-synth
float sdTorus(vec3 p,vec2 t){vec2 q=vec2(length(p.xz)-t.x,p.y);return length(q)-t.y;}
mat3 rotX(float a){float c=cos(a),s=sin(a);return mat3(1,0,0,0,c,-s,0,s,c);}
mat3 rotZ(float a){float c=cos(a),s=sin(a);return mat3(c,-s,0,s,c,0,0,0,1);}
float map(vec3 p,float t){
  float d=1e9;
  for(float i=0.0;i<4.0;i++){
    float a=i*1.5708+t*0.3;
    vec3 q=rotX(a)*rotZ(a*0.618)*p;
    d=min(d,sdTorus(q,vec2(0.6*u_scale,0.12*u_scale)));
  }
  return d;
}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed*0.5;
  vec3 ro=vec3(0,0,3.5);
  vec3 rd=normalize(vec3(uv,-1.5));
  mat3 ry=mat3(cos(t*0.4),0,sin(t*0.4),0,1,0,-sin(t*0.4),0,cos(t*0.4));
  ro=ry*ro;rd=ry*rd;
  float d=0.0;vec3 p=ro;bool hit=false;
  for(int i=0;i<80;i++){float s=map(p,t);if(s<0.003){hit=true;break;}d+=s;p=ro+rd*d;if(d>10.0)break;}
  vec3 col=vec3(0.0);
  if(hit){
    float eps=0.003;
    vec3 n=normalize(vec3(map(p+vec3(eps,0,0),t)-map(p-vec3(eps,0,0),t),map(p+vec3(0,eps,0),t)-map(p-vec3(0,eps,0),t),map(p+vec3(0,0,eps),t)-map(p-vec3(0,0,eps),t)));
    float diff=max(dot(n,normalize(vec3(1,2,1))),0.0);
    float spec=pow(max(dot(reflect(-normalize(vec3(1,2,1)),n),normalize(ro-p)),0.0),32.0);
    float hue=atan(p.z,p.x)/6.28318+p.y*0.5+t*0.1;
    col=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*(diff*0.7+0.15)+vec3(1.0)*spec*0.4;
    col+=vec3(0.3,0.0,0.8)*pow(1.0-diff,2.0)*0.3;
  }else{col=vec3(0.02,0.01,0.04);}
  outColor=vec4(col*u_intensity,1.0);}
