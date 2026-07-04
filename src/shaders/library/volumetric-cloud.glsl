// name: VOLUMETRIC CLOUD
// category: 3d
// ported from prism-video-synth
float hash(vec3 p){return fract(sin(dot(p,vec3(127.1,311.7,74.7)))*43758.5453);}
float noise3(vec3 p){vec3 i=floor(p);vec3 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(mix(hash(i),hash(i+vec3(1,0,0)),f.x),mix(hash(i+vec3(0,1,0)),hash(i+vec3(1,1,0)),f.x),f.y),mix(mix(hash(i+vec3(0,0,1)),hash(i+vec3(1,0,1)),f.x),mix(hash(i+vec3(0,1,1)),hash(i+vec3(1,1,1)),f.x),f.y),f.z);}
float fbm3(vec3 p){float v=0.0,a=0.5;for(int i=0;i<5;i++){v+=a*noise3(p);p*=2.0;a*=0.5;}return v;}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed*0.2;
  vec3 ro=vec3(0.0,0.0,3.0);
  vec3 rd=normalize(vec3(uv,-1.5));
  vec3 col=vec3(0.0);float alpha=0.0;
  float step=0.08;
  for(int i=0;i<40;i++){
    vec3 p=ro+rd*(float(i)*step+0.5);
    float d=fbm3(p*u_scale*0.8+vec3(t*0.3,t*0.15,t*0.2));
    d=max(d-0.4,0.0)*2.0;
    float hue=d*0.5+t*0.1+p.y*0.2;
    vec3 c=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*d;
    col+=c*(1.0-alpha)*step*3.0;
    alpha+=d*(1.0-alpha)*step*2.0;
    if(alpha>0.95)break;
  }
  col+=vec3(0.02,0.01,0.04)*(1.0-alpha);
  outColor=vec4(col*u_intensity,1.0);}
