// name: LENS FLARE
// category: light
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 l=0.55*vec2(cos(t*0.3),sin(t*0.21)*0.6);vec2 p=uv*u_scale;float dl=length(p-l);vec3 col=vec3(0.02,0.03,0.07);col+=vec3(1.0,0.9,0.7)*0.1/(dl+0.04);col+=vec3(1.0,0.7,0.4)*exp(-abs(p.y-l.y)*38.0)*exp(-abs(p.x-l.x)*1.6)*0.9;for(int i=0;i<6;i++){float fi=float(i);float k=-0.8+fi*0.4;vec2 gp=l*k;float gr=0.04+fi*0.035;float gd=length(p-gp);float ring=smoothstep(gr,gr*0.75,gd)*(0.5+0.5*smoothstep(gr*0.5,gr,gd));col+=(0.5+0.5*cos(6.28318*(fi*0.16+t*0.05+vec3(0.0,0.33,0.67))))*ring*0.27;}float halo=abs(dl-0.42);col+=(0.5+0.5*cos(6.28318*(dl*1.5+vec3(0.0,0.33,0.67))))*0.012/(halo+0.025);outColor=vec4(audioPop(col*u_intensity),1.0);}
