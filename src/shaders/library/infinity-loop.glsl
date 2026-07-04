// name: INFINITY LOOP
// category: geometric
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*3.0*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;vec3 col=vec3(0.02,0.0,0.05);for(float i=0.0;i<20.0;i++){float fi=i/20.0;float phase=t+fi*6.28318;float sc=1.0-fi*0.3;vec2 inf=vec2(sin(phase),sin(phase*2.0)*0.5)*sc;float d=length(p-inf);float glow=0.02/(d+0.02);col+=(0.5+0.5*cos(fi*6.28318+t+vec3(0.0,2.0,4.0)))*glow*u_intensity*0.15;}outColor=vec4(audioPop(col),1.0);}
