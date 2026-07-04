// name: PLASMA GLOBE
// category: energy
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1.0,0.0)),f.x),mix(hash(i+vec2(0.0,1.0)),hash(i+vec2(1.0,1.0)),f.x),f.y);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*1.3*u_scale;float r=length(p);float a=atan(p.y,p.x);float R=0.82;vec3 col=vec3(0.02,0.0,0.05);for(int i=0;i<7;i++){float fi=float(i);float ai=hash(vec2(fi,floor(t*1.5)))*6.28318+t*0.3;float wob=(sn(vec2(r*5.0-t*2.5,fi*7.0))-0.5)*1.3*r;float ad=abs(mod(a-ai-wob+3.14159,6.28318)-3.14159)*max(r,0.05);float fil=0.006/(ad+0.007)*smoothstep(R,R*0.85,r)*step(r,R);col+=(0.5+0.5*cos(6.28318*(fi*0.13+t*0.1+vec3(0.55,0.8,1.05))))*fil;col+=vec3(1.0,0.8,1.0)*exp(-abs(r-R)*45.0)*exp(-ad*7.0)*0.8;}col+=vec3(0.9,0.6,1.0)*exp(-r*9.0)*1.3;float shell=abs(r-R);col+=vec3(0.4,0.5,0.9)*0.005/(shell+0.012);col+=vec3(0.1,0.05,0.2)*smoothstep(R,0.0,r)*0.4;outColor=vec4(col*u_intensity,1.0);}
