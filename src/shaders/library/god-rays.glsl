// name: GOD RAYS
// category: volumetric
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1.0,0.0)),f.x),mix(hash(i+vec2(0.0,1.0)),hash(i+vec2(1.0,1.0)),f.x),f.y);}
float cloud(vec2 p,float t){float v=0.0,a=0.5;for(int i=0;i<4;i++){v+=a*sn(p+vec2(t*0.15,0.0));p*=2.1;a*=0.55;}return smoothstep(0.45,0.75,v);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 sun=vec2(0.35*sin(t*0.12),0.42);vec2 p=uv*u_scale;float shaft=0.0;for(int i=0;i<24;i++){float fi=float(i)/24.0;vec2 sp=mix(p,sun,fi);shaft+=(1.0-cloud(sp*3.0,t))*(1.0-fi*0.6);}shaft/=24.0;float d=length(p-sun);float occ=cloud(p*3.0,t);vec3 col=mix(vec3(0.03,0.02,0.08),vec3(0.12,0.06,0.2),uv.y+0.5);col+=vec3(1.0,0.85,0.55)*pow(shaft,2.2)*1.4*exp(-d*0.9);col+=vec3(1.0,0.9,0.7)*0.06/(d+0.04)*(1.0-occ*0.8);col=mix(col,vec3(0.05,0.03,0.1),occ*0.75);outColor=vec4(col*u_intensity,1.0);}
