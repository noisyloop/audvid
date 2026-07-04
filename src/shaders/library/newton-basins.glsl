// name: NEWTON BASINS
// category: fractal
// ported from prism-video-synth
vec2 cmul(vec2 a,vec2 b){return vec2(a.x*b.x-a.y*b.y,a.x*b.y+a.y*b.x);}vec2 cdiv(vec2 a,vec2 b){return vec2(a.x*b.x+a.y*b.y,a.y*b.x-a.x*b.y)/max(dot(b,b),1e-8);}void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;float ca=cos(t*0.1),sa=sin(t*0.1);vec2 z=mat2(ca,-sa,sa,ca)*uv*2.4*u_scale+vec2(0.001);float it=0.0;for(int i=0;i<24;i++){vec2 z2=cmul(z,z);vec2 f=cmul(z2,z)-vec2(1.0,0.0);if(dot(f,f)<1e-6)break;z-=cdiv(f,3.0*z2);it+=1.0;}float root=mod(floor((atan(z.y,z.x)+3.14159)/2.0944),3.0);vec3 col=0.5+0.5*cos(6.28318*(root/3.0+t*0.05+vec3(0.0,0.33,0.67)));col*=(1.0-it/24.0*0.85)*(0.8+0.2*sin(it*0.7-t*2.0));col+=vec3(1.0)*exp(-it*0.45)*0.3;outColor=vec4(col*u_intensity,1.0);}
