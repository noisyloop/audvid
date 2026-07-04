// name: CORAL REEF
// category: nature
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1.0,0.0)),f.x),mix(hash(i+vec2(0.0,1.0)),hash(i+vec2(1.0,1.0)),f.x),f.y);}
float fbm(vec2 p){float v=0.0,a=0.5;for(int i=0;i<5;i++){v+=a*sn(p);p*=2.15;a*=0.5;}return v;}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed*0.25;vec2 p=uv*3.2*u_scale;vec2 w=vec2(fbm(p+vec2(t,0.0)),fbm(p+vec2(0.0,t*0.8)+3.0));float v=sin(p.x*5.0+w.x*9.0)+sin(p.y*5.0+w.y*9.0)+sin((p.x+p.y)*3.5-w.x*6.0);float lab=smoothstep(0.35,0.0,abs(v*0.33));float spots=smoothstep(0.55,0.75,fbm(p*2.6+w*3.0+t*0.5));vec3 col=mix(vec3(0.03,0.1,0.16),vec3(0.0,0.25,0.3),uv.y+0.5);col=mix(col,vec3(1.0,0.4,0.3),lab*0.85);col=mix(col,vec3(1.0,0.75,0.3),spots*lab);col=mix(col,vec3(0.65,0.1,0.45),spots*(1.0-lab)*0.7);col+=vec3(0.2,0.5,0.5)*fbm(p*1.3-t)*0.25;outColor=vec4(col*u_intensity,1.0);}
