// name: FIBONACCI ROSE
// category: sacred
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*1.6/max(u_scale,0.1);float ca=cos(t*0.1),sa=sin(t*0.1);p=mat2(ca,-sa,sa,ca)*p;vec3 col=vec3(0.01,0.0,0.02);for(int i=0;i<110;i++){float fi=float(i);float rr=0.095*sqrt(fi);float aa=fi*2.39996+t*0.2;vec2 c=rr*vec2(cos(aa),sin(aa));float d=length(p-c);float sz=0.012+fi*0.0003;float pulse=0.7+0.3*sin(t*2.0-rr*4.0);col+=(0.5+0.5*cos(6.28318*(fi*0.012+t*0.06+vec3(0.0,0.33,0.67))))*(smoothstep(sz,sz*0.2,d)+exp(-d*22.0)*0.25)*pulse;}col+=vec3(1.0,0.9,0.6)*exp(-length(p)*7.0)*0.6;outColor=vec4(audioPop(col*u_intensity),1.0);}
