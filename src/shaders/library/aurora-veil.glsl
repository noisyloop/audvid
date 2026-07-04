// name: AURORA VEIL
// category: volumetric
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec3 ro=vec3(0.0,-0.3,0.0);vec3 rd=normalize(vec3(uv.x,uv.y+0.35,1.2));vec3 col=vec3(0.01,0.01,0.04);for(int i=0;i<40;i++){float d=0.5+float(i)*0.16;vec3 p=ro+rd*d;float w1=sin(p.z*1.3*u_scale+t*0.5)+0.5*sin(p.z*2.7*u_scale-t*0.3)+0.25*sin(p.z*5.1*u_scale+t*0.7);float w2=sin(p.z*1.1*u_scale-t*0.4+2.0)+0.5*sin(p.z*3.1*u_scale+t*0.35);float s1=abs(p.x-w1*0.4);float s2=abs(p.x-w2*0.4-1.1);float band=smoothstep(0.1,0.9,p.y)*smoothstep(3.2,1.2,p.y);float den=(exp(-s1*s1*14.0)+exp(-s2*s2*14.0)*0.7)*band;float hue=0.32+p.y*0.13-den*0.1;vec3 c=0.5+0.5*cos(6.28318*(hue+vec3(0.0,0.33,0.67)));col+=c*den*exp(-d*0.25)*0.05;}col+=vec3(1.0)*step(0.9985,hash(floor(uv*vec2(200.0,120.0))))*0.5;outColor=vec4(col*u_intensity,1.0);}
