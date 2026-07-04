// name: MAGNETIC LINES
// category: flow
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*2.0*u_scale;float phi=0.0;float poles=0.0;for(int i=0;i<3;i++){float fi=float(i);vec2 c=0.55*vec2(cos(t*(0.3+fi*0.1)+fi*2.094),sin(t*(0.23+fi*0.08)+fi*2.094));vec2 m=vec2(cos(t*0.5+fi*2.0),sin(t*0.5+fi*2.0));vec2 d=p-c;float r2=max(dot(d,d),0.003);phi+=dot(m,d)/r2;poles+=0.012/r2;}float v=sin(phi*4.0-t*1.5);float lines=smoothstep(0.75,0.98,abs(v));vec3 col=(0.5+0.5*cos(6.28318*(phi*0.08+t*0.06+vec3(0.0,0.33,0.67))))*(0.15+lines*1.1);col+=vec3(1.0,0.8,0.5)*min(poles,2.0)*0.35;outColor=vec4(col*u_intensity,1.0);}
