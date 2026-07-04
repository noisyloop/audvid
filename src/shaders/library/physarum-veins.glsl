// name: PHYSARUM VEINS
// category: organic
// ported from prism-video-synth
vec2 hash2(vec2 p){return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*4.5*u_scale;vec2 n=floor(p);vec2 f=fract(p);float d1=8.0,d2=8.0;vec2 mv=vec2(0.0);for(int j=-1;j<=1;j++)for(int i=-1;i<=1;i++){vec2 g=vec2(float(i),float(j));vec2 o=hash2(n+g);o=0.5+0.45*sin(t*0.6+6.2831*o);vec2 r=g+o-f;float d=dot(r,r);if(d<d1){d2=d1;d1=d;mv=r;}else if(d<d2)d2=d;}float edge=sqrt(d2)-sqrt(d1);float vein=smoothstep(0.14,0.0,edge);float flow=0.5+0.5*sin(sqrt(d1)*9.0-t*3.0+atan(mv.y,mv.x));vec3 col=vec3(0.04,0.02,0.01);col+=vec3(0.95,0.75,0.1)*vein*(0.35+0.75*flow);col+=vec3(1.0,0.95,0.5)*smoothstep(0.04,0.0,edge)*flow*0.8;col+=vec3(0.35,0.2,0.04)*smoothstep(0.5,0.0,sqrt(d1))*(1.0-vein)*0.5;outColor=vec4(audioPop(col*u_intensity),1.0);}
