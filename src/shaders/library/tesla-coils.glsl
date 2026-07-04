// name: TESLA COILS
// category: energy
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1.0,0.0)),f.x),mix(hash(i+vec2(0.0,1.0)),hash(i+vec2(1.0,1.0)),f.x),f.y);}
float arc(vec2 p,float t,float seed){float seg=floor(t*9.0)+seed*37.0;float yb=0.15+0.12*sin(p.x*3.0+seed*5.0);float disp=(sn(vec2(p.x*6.0+seed*13.0,seg))-0.5)*0.34+(sn(vec2(p.x*16.0-seed*7.0,seg*1.7))-0.5)*0.12;float mask=smoothstep(0.68,0.55,abs(p.x));return 0.008/(abs(p.y-yb-disp*mask)+0.009)*mask;}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*1.4*u_scale;vec3 col=vec3(0.015,0.01,0.04);float tower=smoothstep(0.05,0.02,abs(abs(p.x)-0.6))*smoothstep(0.2,-0.45,p.y);col+=vec3(0.25,0.3,0.45)*tower;col+=vec3(0.6,0.7,1.0)*(exp(-length(p-vec2(-0.6,0.18))*8.0)+exp(-length(p-vec2(0.6,0.18))*8.0))*(0.7+0.3*sin(t*30.0));col+=vec3(0.55,0.6,1.0)*arc(p,t,1.0);col+=vec3(0.75,0.6,1.0)*arc(p,t*1.13,2.0)*0.8;col+=vec3(0.9,0.9,1.0)*arc(p,t*0.91,3.0)*0.6;col+=vec3(0.3,0.2,0.6)*exp(-abs(p.y-0.15)*2.5)*0.25*(0.6+0.4*sin(t*17.0));outColor=vec4(col*u_intensity,1.0);}
