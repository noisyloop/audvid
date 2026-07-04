// name: OSCILLOSCOPE XY
// category: audio
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*1.3*u_scale;float fx=3.0+floor(mod(t*0.21,4.0));float fy=2.0+floor(mod(t*0.13,3.0));float ph=t*0.5;vec3 col=vec3(0.01,0.03,0.02);vec2 g=abs(fract(p*2.5+0.5)-0.5);col+=vec3(0.0,0.12,0.05)*smoothstep(0.03,0.0,min(g.x,g.y));float glow=0.0;for(int i=0;i<64;i++){float fi=float(i)/64.0;float s=t*1.2-fi*0.55;vec2 c=0.75*vec2(sin(fx*s+ph),sin(fy*s));float d=length(p-c);glow+=exp(-d*90.0)*(1.0-fi)*1.4+exp(-d*18.0)*(1.0-fi)*0.06;}col+=vec3(0.25,1.0,0.45)*glow;col+=vec3(0.7,1.0,0.8)*glow*glow*0.05;outColor=vec4(audioPop(col*u_intensity),1.0);}
