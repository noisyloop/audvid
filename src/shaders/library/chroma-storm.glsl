// name: CHROMA STORM
// category: psychedelic
// ported from prism-video-synth
mat2 rot(float a){float c=cos(a),s=sin(a);return mat2(c,-s,s,c);}float field(vec2 p,float t){return sin(p.x*3.0+sin(p.y*2.7+t*1.3))+sin(p.y*3.4+sin(p.x*2.2-t));}void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*2.2*u_scale;float r0=length(p);p=rot(1.2*exp(-r0*1.2)*sin(t*0.5))*p;float fr=field(rot(0.06)*p,t);float fg=field(p,t+0.13);float fb=field(rot(-0.06)*p,t+0.26);vec3 col=vec3(fr,fg,fb)*0.25+0.5;col=pow(clamp(col,0.0,1.0),vec3(1.6))*1.5;col+=(0.5+0.5*cos(6.28318*(r0*0.4+t*0.1+vec3(0.0,0.33,0.67))))*exp(-r0*1.5)*0.4;outColor=vec4(col*u_intensity,1.0);}
