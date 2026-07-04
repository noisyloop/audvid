// name: WARP NEXUS
// category: psychedelic
// ported from prism-video-synth
mat2 rot(float a){float c=cos(a),s=sin(a);return mat2(c,-s,s,c);}void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*2.0*u_scale;float glow=0.0;for(int i=0;i<4;i++){float fi=float(i);vec2 c=0.55*vec2(cos(t*0.4+fi*1.5708),sin(t*0.31+fi*1.5708));vec2 d=p-c;float r=length(d);p=c+rot(1.6*exp(-r*2.2)*sin(t*0.6+fi))*d;glow+=0.012/(r*r+0.02);}float stripes=sin((p.x+p.y)*9.0+t)+sin((p.x-p.y)*7.0-t*0.7);vec3 col=(0.5+0.5*cos(6.28318*(stripes*0.1+p.x*0.15+t*0.09+vec3(0.0,0.33,0.67))))*(0.5+0.5*stripes*0.5);col+=(0.5+0.5*cos(6.28318*(glow*0.3+t*0.15+vec3(0.5,0.83,1.17))))*glow*0.6;outColor=vec4(audioPop(col*u_intensity),1.0);}
