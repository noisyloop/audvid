// name: ASTEROID FIELD
// category: space
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
vec2 hash2(vec2 p){return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);}
float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1.0,0.0)),f.x),mix(hash(i+vec2(0.0,1.0)),hash(i+vec2(1.0,1.0)),f.x),f.y);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec3 col=vec3(0.01,0.01,0.035);col+=vec3(1.0)*step(0.993,hash(floor(uv*110.0)))*0.4;for(int L=0;L<3;L++){float fl=float(L);float sc=(2.0+fl*2.0)*u_scale;vec2 p=uv*sc+vec2(t*(0.25+fl*0.18),sin(t*0.1+fl)*0.2);vec2 id=floor(p);vec2 f=fract(p);vec2 j=hash2(id)*0.5+0.25;float sz=(0.1+hash(id+3.7)*0.16)*step(0.35,hash(id+1.3));float d=length(f-j);float rock=smoothstep(sz,sz*0.75,d);float lit=clamp(0.5+(j.x-f.x)*2.5,0.1,1.0);float tex=0.7+0.5*sn((id+f)*9.0);float bright=(0.85-fl*0.25);col=mix(col,vec3(0.42,0.38,0.34)*lit*tex*bright,rock);col+=vec3(1.0,0.95,0.85)*smoothstep(sz*0.4,0.0,d)*step(0.93,hash(id+floor(t*2.0)*0.1))*0.45*rock;}outColor=vec4(col*u_intensity,1.0);}
