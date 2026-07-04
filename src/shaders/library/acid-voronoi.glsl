// name: ACID VORONOI
// category: psychedelic
// ported from prism-video-synth
vec2 hash2(vec2 p){return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);}
void main(){
  vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;
  float t=u_time*u_speed;
  vec2 p=uv*5.0*u_scale;
  vec2 warp=vec2(sin(p.y*1.3+t)*0.3,cos(p.x*1.1-t*0.7)*0.3);
  p+=warp;
  vec2 n=floor(p),f=fract(p);
  float d1=8.0,d2=8.0;vec2 mv=vec2(0.0);
  for(int j=-2;j<=2;j++)for(int i=-2;i<=2;i++){
    vec2 g=vec2(float(i),float(j));
    vec2 o=hash2(n+g);
    o=0.5+0.5*sin(t*1.3+6.2831*o);
    vec2 r=g+o-f;float d=dot(r,r);
    if(d<d1){d2=d1;d1=d;mv=r;}
    else if(d<d2)d2=d;
  }
  float edge=smoothstep(0.0,0.05,sqrt(d2)-sqrt(d1));
  float hue=atan(mv.y,mv.x)/6.28318+sqrt(d1)*0.5+t*0.12;
  vec3 col=(0.5+0.5*cos(hue*6.28318*2.0+vec3(0.0,2.09,4.18)))*edge;
  col+=vec3(1.0,0.5,0.9)*(1.0-edge)*0.15;
  col+=vec3(0.0,1.0,0.6)*smoothstep(0.03,0.0,sqrt(d2)-sqrt(d1))*2.0;
  outColor=vec4(col*u_intensity,1.0);}
