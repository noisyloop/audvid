// name: FIREWALL
// category: cyber
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float hexDist(vec2 p){p=abs(p);return max(dot(p,vec2(0.866025,0.5)),p.y);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*5.5*u_scale;vec2 r=vec2(1.0,1.7320508);vec2 h2=r*0.5;vec2 a=mod(p,r)-h2;vec2 b=mod(p-h2,r)-h2;vec2 gv=dot(a,a)<dot(b,b)?a:b;vec2 id=p-gv;float hd=hexDist(gv);float imp=0.0;for(int i=0;i<3;i++){float fi=float(i);float cyc=floor(t*0.8+fi*0.33);vec2 ic=(vec2(hash(vec2(cyc,fi)),hash(vec2(cyc,fi+5.0)))-0.5)*vec2(5.0,3.0);float age=fract(t*0.8+fi*0.33);float rr=age*3.5;imp+=exp(-abs(length(id-ic)-rr)*1.8)*(1.0-age);}float border=smoothstep(0.06,0.015,abs(hd-0.44));vec3 col=vec3(0.0,0.06,0.09);col+=vec3(0.0,0.55,0.6)*border*(0.4+0.3*sin(t*2.0+hash(id)*6.28));col+=vec3(1.0,0.45,0.1)*border*imp*2.2;col+=vec3(1.0,0.25,0.05)*smoothstep(0.4,0.0,hd)*imp*0.55;col+=vec3(0.0,0.3,0.35)*smoothstep(0.4,0.0,hd)*0.12;outColor=vec4(audioPop(col*u_intensity),1.0);}
