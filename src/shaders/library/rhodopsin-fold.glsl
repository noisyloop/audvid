// name: RHODOPSIN FOLD
// category: 3d
// ported from prism-video-synth
float hash(vec3 p){return fract(sin(dot(p,vec3(127.1,311.7,74.7)))*43758.5453);}
float noise3(vec3 p){vec3 i=floor(p);vec3 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(mix(hash(i),hash(i+vec3(1,0,0)),f.x),mix(hash(i+vec3(0,1,0)),hash(i+vec3(1,1,0)),f.x),f.y),mix(mix(hash(i+vec3(0,0,1)),hash(i+vec3(1,0,1)),f.x),mix(hash(i+vec3(0,1,1)),hash(i+vec3(1,1,1)),f.x),f.y),f.z);}
float map(vec3 p,float t){
  vec3 q=p;
  q.x+=sin(q.z*2.0+t)*0.4;
  q.y+=sin(q.x*1.5-t*0.7)*0.4;
  float n=noise3(q*u_scale+vec3(t*0.2))*0.5;
  float n2=noise3(q*u_scale*2.3-vec3(t*0.3,t*0.1,0))*0.25;
  float shell=length(p)-1.2+n+n2;
  float gyroid=dot(sin(p*u_scale*2.0+t*0.3),cos(p.yzx*u_scale*2.0-t*0.2))*0.15;
  return shell+gyroid;
}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed;
  vec3 ro=vec3(sin(t*0.2)*0.5,cos(t*0.15)*0.3,3.5);
  vec3 rd=normalize(vec3(uv,-1.6));
  float d=0.5;vec3 p=ro;bool hit=false;
  for(int i=0;i<80;i++){float s=map(p,t);if(s<0.004){hit=true;break;}d+=s*0.6;p=ro+rd*d;if(d>8.0)break;}
  vec3 col=vec3(0.0);
  if(hit){
    float eps=0.01;
    vec3 n=normalize(vec3(map(p+vec3(eps,0,0),t)-map(p-vec3(eps,0,0),t),map(p+vec3(0,eps,0),t)-map(p-vec3(0,eps,0),t),map(p+vec3(0,0,eps),t)-map(p-vec3(0,0,eps),t)));
    vec3 ld=normalize(vec3(sin(t),cos(t*0.7),1.0));
    float diff=max(dot(n,ld),0.0);
    float spec=pow(max(dot(reflect(-ld,n),normalize(ro-p)),0.0),48.0);
    float fres=pow(1.0-max(dot(n,normalize(ro-p)),0.0),3.0);
    float hue=p.x*0.4+p.y*0.3+d*0.15+t*0.1;
    col=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*(diff*0.7+0.15);
    col+=vec3(1.0,0.5,0.9)*spec*0.8+vec3(0.3,0.1,0.9)*fres*0.5;
  }else{
    float hue=length(uv)*0.5+t*0.05;
    col=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*0.05;
  }
  outColor=vec4(audioPop(col*u_intensity),1.0);}
