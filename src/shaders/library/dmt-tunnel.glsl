// name: DMT TUNNEL
// category: psychedelic
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed;
  float r=length(uv);float a=atan(uv.y,uv.x);
  vec3 col=vec3(0.0);
  float depth=1.0/(r+0.02)-t*2.0;
  for(float i=0.0;i<8.0;i++){
    float fi=i/8.0;
    float layer=fract(depth+fi);
    float hue=a/6.28318+layer*0.5+fi*0.3+t*0.1;
    float geom=sin(a*floor(3.0+i)+layer*12.0+t*(1.0+fi))*0.5+0.5;
    geom*=sin(a*floor(5.0+i*1.3)-layer*8.0-t*(0.7+fi*0.5))*0.5+0.5;
    float v=pow(geom,2.0)*smoothstep(0.0,0.2,layer)*smoothstep(1.0,0.7,layer);
    col+=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*v/8.0;
  }
  col*=u_intensity*(0.5+0.5/(r+0.1));
  outColor=vec4(audioPop(col),1.0);}
