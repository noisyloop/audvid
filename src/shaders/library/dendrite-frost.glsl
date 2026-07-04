// name: DENDRITE FROST
// category: nature
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1.0,0.0)),f.x),mix(hash(i+vec2(0.0,1.0)),hash(i+vec2(1.0,1.0)),f.x),f.y);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*2.0*u_scale;float r=length(p);float a=atan(p.y,p.x);float sec=0.5236;float af=abs(mod(a,2.0*sec)-sec);vec2 q=vec2(cos(af),sin(af))*r;float ridge=0.0;float amp=0.55;vec2 rp=q*3.0;for(int i=0;i<5;i++){ridge+=amp*(1.0-abs(2.0*sn(rp+t*0.1)-1.0));rp*=2.2;amp*=0.5;}float grow=mod(t*0.22,2.2);float front=smoothstep(grow,grow-0.5,r);float frost=pow(ridge,3.2)*front;float vein=smoothstep(0.06,0.0,q.y*(1.0+r))*front*smoothstep(grow,0.0,r);vec3 col=vec3(0.01,0.03,0.08);col+=vec3(0.45,0.7,0.95)*frost*1.1;col+=vec3(0.85,0.95,1.0)*vein*0.9;col+=vec3(1.0)*pow(frost,3.0)*step(0.93,hash(floor(p*40.0)))*1.5;col+=vec3(0.5,0.8,1.0)*exp(-abs(r-grow)*9.0)*front*0.4;outColor=vec4(col*u_intensity,1.0);}
