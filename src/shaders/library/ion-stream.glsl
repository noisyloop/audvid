// name: ION STREAM
// category: energy
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*u_scale;vec3 col=vec3(0.01,0.01,0.04);for(int i=0;i<5;i++){float fi=float(i);float yi=(fi/2.0-1.0)*0.42;float path=yi+0.16*sin(p.x*2.2+t*(0.8+fi*0.2)+fi*2.4);float d=abs(p.y-path);float core=0.0035/(d+0.004);float bunch=0.0;for(int j=0;j<3;j++){float fj=float(j);float bx=fract(p.x*0.4-t*(0.35+fi*0.08)+fj*0.333+fi*0.21)-0.5;bunch+=exp(-bx*bx*150.0);}col+=(0.5+0.5*cos(6.28318*(fi*0.16+t*0.06+vec3(0.45,0.7,1.0))))*(core*(0.4+bunch*1.6))*0.55;col+=vec3(1.0)*exp(-d*120.0)*bunch*0.5;}outColor=vec4(col*u_intensity,1.0);}
