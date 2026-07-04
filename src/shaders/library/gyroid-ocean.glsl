// name: GYROID OCEAN
// category: 3d
// ported from prism-video-synth
float gyroid(vec3 p){return dot(sin(p),cos(p.yzx));}
float map(vec3 p,float t){
  p*=u_scale*1.5;
  float g=gyroid(p+vec3(t*0.3,t*0.2,t*0.15));
  float g2=gyroid(p*2.0+vec3(-t*0.5,t*0.3,t*0.4))*0.5;
  return g+g2-0.3;
}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed;
  vec3 ro=vec3(0.0,0.0,4.0);
  vec3 rd=normalize(vec3(uv,-1.8));
  float d=0.0;vec3 p=ro;float hit=0.0;int steps=0;
  for(int i=0;i<64;i++){
    float s=map(p,t)*0.4;
    if(abs(s)<0.003){hit=float(i)/64.0;break;}
    d+=s;p=ro+rd*d;steps=i;
    if(d>8.0)break;
  }
  vec3 col=vec3(0.0);
  if(hit>0.0){
    float eps=0.01;
    vec3 n=normalize(vec3(map(p+vec3(eps,0,0),t)-map(p-vec3(eps,0,0),t),map(p+vec3(0,eps,0),t)-map(p-vec3(0,eps,0),t),map(p+vec3(0,0,eps),t)-map(p-vec3(0,0,eps),t)));
    float diff=max(dot(n,normalize(vec3(1,2,1))),0.0);
    float ao=1.0-hit;
    float hue=p.x*0.2+p.y*0.3+p.z*0.1+t*0.15;
    col=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*(diff*0.7+0.3)*ao;
    col+=vec3(0.1,0.5,0.8)*pow(1.0-diff,2.0)*0.4;
  }else{col=vec3(0.02,0.01,0.04);}
  outColor=vec4(audioPop(col*u_intensity),1.0);}
