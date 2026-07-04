// name: MANDALA BLOOM
// category: psychedelic
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*1.6*u_scale;float r=length(p);float a=atan(p.y,p.x);vec3 col=vec3(0.0);for(int i=0;i<5;i++){float fi=float(i);float n=5.0+fi*2.0;float dir=mod(fi,2.0)<0.5?1.0:-1.0;float base=0.16+fi*0.14+0.03*sin(t+fi*1.3);float amp=0.05+0.02*sin(t*0.7+fi);float d=abs(r-base-amp*cos(a*n+t*0.4*dir));float v=smoothstep(0.018,0.0,d-0.004)+0.005/(d+0.012);col+=(0.5+0.5*cos(6.28318*(fi*0.17+r*0.3+t*0.07+vec3(0.0,0.33,0.67))))*v*0.5;}col+=vec3(1.0,0.9,0.7)*exp(-r*8.0)*(0.5+0.5*sin(t*2.0));outColor=vec4(audioPop(col*u_intensity),1.0);}
