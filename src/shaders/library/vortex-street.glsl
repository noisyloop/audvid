// name: VORTEX STREET
// category: flow
// ported from prism-video-synth
mat2 rot(float a){float c=cos(a),s=sin(a);return mat2(c,-s,s,c);}void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*2.0*u_scale;float glow=0.0;for(int i=0;i<6;i++){float fi=float(i);float sgn=mod(fi,2.0)<0.5?1.0:-1.0;vec2 vp=vec2(mod(fi*1.3-t*0.5,4.0)-2.0,sgn*0.32+0.06*sin(t+fi));vec2 d=p-vp;float r=length(d);p=vp+rot(sgn*1.8*exp(-r*r*3.0))*d;glow+=0.004/(r*r+0.01);}float stripes=sin(p.y*11.0+sin(p.x*2.0))+0.5*sin(p.x*5.0-t*0.8);vec3 col=(0.5+0.5*cos(6.28318*(stripes*0.1+p.y*0.12+t*0.05+vec3(0.0,0.33,0.67))))*(0.45+0.4*stripes*0.5);col+=vec3(0.8,0.95,1.0)*glow*0.7;outColor=vec4(col*u_intensity,1.0);}
