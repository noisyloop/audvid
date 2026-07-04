// name: ORBIT TRAP GARDEN
// category: fractal
// ported from prism-video-synth
vec2 cmul(vec2 a,vec2 b){return vec2(a.x*b.x-a.y*b.y,a.x*b.y+a.y*b.x);}void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 z=uv*1.8*u_scale;vec2 c=vec2(-0.745+0.05*sin(t*0.37),0.186+0.05*cos(t*0.29));vec2 tc=0.35*vec2(cos(t*0.8),sin(t*0.8));float trC=1e9,trL=1e9;for(int i=0;i<36;i++){z=cmul(z,z)+c;trC=min(trC,abs(length(z-tc)-0.35));trL=min(trL,min(abs(z.x),abs(z.y)));if(dot(z,z)>36.0)break;}vec3 col=(0.5+0.5*cos(6.28318*(trC*1.2+t*0.1+vec3(0.0,0.33,0.67))))*exp(-trC*3.5);col+=vec3(1.0,0.95,0.8)*exp(-trL*8.0)*0.45;col+=vec3(0.3,0.05,0.4)*exp(-trC*0.8)*0.3;outColor=vec4(col*u_intensity,1.0);}
