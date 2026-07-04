// name: ALIEN MEMBRANE
// category: 3d
// ported from prism-video-synth
float hash(vec3 p){return fract(sin(dot(p,vec3(127.1,311.7,74.7)))*43758.5453);}
float n3(vec3 p){vec3 i=floor(p);vec3 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(mix(hash(i),hash(i+vec3(1,0,0)),f.x),mix(hash(i+vec3(0,1,0)),hash(i+vec3(1,1,0)),f.x),f.y),mix(mix(hash(i+vec3(0,0,1)),hash(i+vec3(1,0,1)),f.x),mix(hash(i+vec3(0,1,1)),hash(i+vec3(1,1,1)),f.x),f.y),f.z);}
float map(vec3 p,float t){
  float r=length(p);
  float theta=acos(p.y/max(r,0.001));
  float phi=atan(p.z,p.x);
  float spikes=0.0;
  for(float i=0.0;i<5.0;i++){spikes+=sin(theta*3.0+i*1.26+t)*cos(phi*4.0+i*0.5-t*0.7)*0.06;}
  float membrane=r-0.9*u_scale-spikes-n3(p*2.0*u_scale+t*0.2)*0.12-n3(p*5.0*u_scale-t*0.3)*0.04;
  return membrane;
}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed;
  vec3 ro=vec3(sin(t*0.3)*0.3,cos(t*0.25)*0.2,3.2);
  vec3 rd=normalize(vec3(uv,-1.5));
  float d=0.3;vec3 p=ro;bool hit=false;
  for(int i=0;i<90;i++){float s=map(p,t);if(abs(s)<0.004){hit=true;break;}d+=s*0.7;p=ro+rd*d;if(d>8.0)break;}
  vec3 col=vec3(0.0);
  if(hit){
    float eps=0.008;
    vec3 n=normalize(vec3(map(p+vec3(eps,0,0),t)-map(p-vec3(eps,0,0),t),map(p+vec3(0,eps,0),t)-map(p-vec3(0,eps,0),t),map(p+vec3(0,0,eps),t)-map(p-vec3(0,0,eps),t)));
    vec3 ld=normalize(vec3(cos(t*0.5),sin(t*0.3),1.0));
    float diff=max(dot(n,ld),0.0);
    float spec=pow(max(dot(reflect(-ld,n),normalize(ro-p)),0.0),64.0);
    float fres=pow(1.0-abs(dot(n,normalize(ro-p))),4.0);
    float hue=p.x*0.5+p.z*0.4+t*0.15;
    col=(0.5+0.5*cos(hue*6.28318+vec3(1.0,2.09,4.18)))*(diff*0.6+0.1);
    col+=vec3(0.2,1.0,0.5)*spec*0.6;
    col+=vec3(0.0,0.5,1.0)*fres*0.4;
    col+=vec3(0.4,0.0,0.8)*(1.0-diff)*0.2;
  }else{col=vec3(0.01,0.02,0.03);}
  outColor=vec4(col*u_intensity,1.0);}
