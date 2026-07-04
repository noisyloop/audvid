// name: INFINITE ZOOM
// category: psychedelic
// ported from prism-video-synth
float noise(vec2 p){return fract(sin(dot(p,vec2(12.9898,78.233)))*43758.5453);}
float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(noise(i),noise(i+vec2(1,0)),f.x),mix(noise(i+vec2(0,1)),noise(i+vec2(1,1)),f.x),f.y);}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed;
  vec2 p=uv;
  float zoom=exp(mod(t*0.5,log(2.0*u_scale)));
  p*=zoom;
  vec3 col=vec3(0.0);
  for(float i=0.0;i<5.0;i++){
    float s=pow(2.0,i);
    float n1=sn(p*s+vec2(t*0.3,-t*0.2));
    float n2=sn(p*s*1.7+vec2(-t*0.25,t*0.35));
    float v=n1*n2;
    float hue=v+i*0.2+t*0.08;
    col+=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*v*(0.5/s);
  }
  col*=u_intensity*1.5;
  outColor=vec4(col,1.0);}
