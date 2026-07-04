// name: LYAPUNOV SPACE
// category: fractal
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 q=uv*1.4*u_scale+vec2(0.25*sin(t*0.11),0.25*cos(t*0.09));float A=clamp(3.12+q.x*0.85,2.2,4.0);float B=clamp(3.12+q.y*0.85,2.2,4.0);float x=0.5;for(int i=0;i<10;i++){float r=mod(float(i),2.0)<0.5?A:B;x=r*x*(1.0-x);}float ly=0.0;for(int i=0;i<36;i++){float r=mod(float(i),2.0)<0.5?A:B;x=r*x*(1.0-x);ly+=log(abs(r*(1.0-2.0*x))+1e-6);}ly/=36.0;float stab=clamp(-ly*1.6,0.0,1.0);float cha=clamp(ly*2.2,0.0,1.0);vec3 col=mix(vec3(0.08,0.02,0.12),vec3(1.0,0.8,0.25),stab);col=mix(col,vec3(0.15,0.45,0.95),pow(stab,4.0));col=mix(col,vec3(0.02,0.0,0.08),cha);col*=0.85+0.15*sin(ly*30.0+t);outColor=vec4(audioPop(col*u_intensity),1.0);}
