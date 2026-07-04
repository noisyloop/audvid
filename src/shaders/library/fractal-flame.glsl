// name: FRACTAL FLAME
// category: psychedelic
// ported from prism-video-synth
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed;
  vec2 p=uv*u_scale;
  vec3 col=vec3(0.0);
  for(float i=0.0;i<6.0;i++){
    float fi=i/6.0;
    vec2 q=p;
    for(int j=0;j<5;j++){
      q=abs(q)/dot(q,q)-vec2(0.5+sin(t*0.3+fi)*0.2,0.2+cos(t*0.2+fi)*0.15);
    }
    float v=1.0/(length(q)+0.1);
    v=min(v,2.0);
    float hue=fi+t*0.1+length(q)*0.2;
    col+=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*v*0.3;
  }
  outColor=vec4(audioPop(col*u_intensity),1.0);}
