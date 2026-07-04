// name: MOIRÉ DREAM
// category: psychedelic
// ported from prism-video-synth
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed;
  vec2 p=uv*u_scale*8.0;
  float v=0.0;
  for(float i=0.0;i<6.0;i++){
    float fi=i/6.0;
    float ang=fi*3.14159+t*0.15*(1.0+fi*0.5);
    float c2=cos(ang),s2=sin(ang);
    vec2 rp=vec2(c2*p.x-s2*p.y,s2*p.x+c2*p.y);
    float freq=10.0+i*3.0;
    v+=sin(rp.x*freq+t*(0.5+fi*0.3))*sin(rp.y*freq*0.7-t*(0.4+fi*0.2));
  }
  v/=6.0;
  float hue=v*0.5+atan(uv.y,uv.x)/6.28318+t*0.08;
  vec3 col=0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18));
  col*=0.7+0.3*sin(v*8.0+t);
  outColor=vec4(col*u_intensity,1.0);}
