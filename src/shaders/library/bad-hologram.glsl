// name: BAD HOLOGRAM
// category: glitch
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1.0,0.0)),f.x),mix(hash(i+vec2(0.0,1.0)),hash(i+vec2(1.0,1.0)),f.x),f.y);}
float body(vec2 p,float t){float r=length(p*vec2(1.0,0.75));return smoothstep(0.02,-0.02,r-0.5-sn(vec2(atan(p.y,p.x)*2.0+10.0,t*0.5))*0.16);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*1.4*u_scale;float slice=step(0.9,hash(vec2(floor(p.y*22.0),floor(t*9.0))));p.x+=slice*(hash(vec2(floor(p.y*22.0),floor(t*9.0)+0.3))-0.5)*0.22;float fl=0.72+0.28*sin(t*43.0)*sin(t*7.3);fl*=1.0-0.55*step(0.94,hash(vec2(floor(t*12.0),2.0)));float bR=body(p-vec2(0.008,0.0),t);float bC=body(p,t);float bB=body(p+vec2(0.008,0.0),t);vec3 col=vec3(bR*0.35,bC*0.95,bB*1.0)*fl;col*=0.6+0.4*sin(uv.y*240.0+t*6.0);col+=vec3(0.2,0.9,1.0)*bC*sn(p*7.0+t*0.4)*0.3*fl;vec2 g=abs(fract(uv*vec2(9.0,5.0)+vec2(0.0,t*0.12))-0.5);col+=vec3(0.05,0.25,0.3)*smoothstep(0.04,0.01,min(g.x,g.y))*(0.4-0.3*bC);outColor=vec4(audioPop(col*u_intensity),1.0);}
