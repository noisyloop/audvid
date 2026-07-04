// name: MENGER SPONGE
// category: 3d
// ported from prism-video-synth
float sdBox(vec3 p,vec3 b){vec3 d=abs(p)-b;return length(max(d,0.0))+min(max(d.x,max(d.y,d.z)),0.0);}
float menger(vec3 p){
  float d=sdBox(p,vec3(1.0));
  float s=1.0;
  for(int i=0;i<4;i++){
    vec3 a=mod(p*s,2.0)-1.0;
    s*=3.0;
    vec3 r=abs(1.0-3.0*abs(a));
    float da=max(r.x,r.y);float db=max(r.y,r.z);float dc=max(r.z,r.x);
    float c=(min(da,min(db,dc))-1.0)/s;
    d=max(d,c);
  }
  return d;
}
mat3 rotY(float a){float c=cos(a),s=sin(a);return mat3(c,0,s,0,1,0,-s,0,c);}
mat3 rotX(float a){float c=cos(a),s=sin(a);return mat3(1,0,0,0,c,-s,0,s,c);}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed*0.3;
  vec3 ro=vec3(0.0,0.0,3.0);
  vec3 rd=normalize(vec3(uv,-1.5));
  mat3 ry=rotY(t*0.5);mat3 rx=rotX(t*0.3);
  ro=ry*rx*ro;rd=ry*rx*rd;
  float d=0.0;vec3 p=ro;bool hit=false;
  for(int i=0;i<100;i++){float s=menger(p/u_scale)*u_scale;if(s<0.002){hit=true;break;}d+=s;p=ro+rd*d;if(d>10.0)break;}
  vec3 col=vec3(0.0);
  if(hit){
    float eps=0.002;
    vec3 n=normalize(vec3(menger((p+vec3(eps,0,0))/u_scale)-menger((p-vec3(eps,0,0))/u_scale),menger((p+vec3(0,eps,0))/u_scale)-menger((p-vec3(0,eps,0))/u_scale),menger((p+vec3(0,0,eps))/u_scale)-menger((p-vec3(0,0,eps))/u_scale)));
    float diff=max(dot(n,normalize(vec3(1,1,1))),0.0);
    float spec=pow(max(dot(reflect(-normalize(vec3(1,1,1)),n),normalize(ro-p)),0.0),16.0);
    float hue=d*0.1+t*0.3;
    col=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*(diff*0.6+0.2)+vec3(1.0)*spec*0.4;
  }else{col=vec3(0.03,0.02,0.05);}
  outColor=vec4(col*u_intensity,1.0);}
