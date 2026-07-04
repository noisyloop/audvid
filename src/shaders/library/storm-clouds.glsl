// name: STORM CLOUDS
// category: volumetric
// ported from prism-video-synth
float hash3(vec3 p){return fract(sin(dot(p,vec3(127.1,311.7,74.7)))*43758.5453);}
float n3(vec3 p){vec3 i=floor(p);vec3 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(mix(hash3(i),hash3(i+vec3(1,0,0)),f.x),mix(hash3(i+vec3(0,1,0)),hash3(i+vec3(1,1,0)),f.x),f.y),mix(mix(hash3(i+vec3(0,0,1)),hash3(i+vec3(1,0,1)),f.x),mix(hash3(i+vec3(0,1,1)),hash3(i+vec3(1,1,1)),f.x),f.y),f.z);}
float fbm3(vec3 p){float v=0.0,a=0.5;for(int i=0;i<5;i++){v+=a*n3(p);p*=2.05;a*=0.5;}return v;}
float hash1(float n){return fract(sin(n)*43758.5453);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec3 ro=vec3(0.0,0.0,2.8);vec3 rd=normalize(vec3(uv,-1.5));float fl=step(0.93,hash1(floor(t*4.0)))*(0.5+0.5*hash1(floor(t*4.0)+0.5));vec2 flpos=vec2(hash1(floor(t*4.0)+1.0)-0.5,hash1(floor(t*4.0)+2.0)-0.5)*1.6;vec3 col=vec3(0.0);float alpha=0.0;for(int i=0;i<36;i++){vec3 p=ro+rd*(float(i)*0.11+0.5);float den=max(fbm3(p*u_scale*1.1+vec3(t*0.25,t*0.1,t*0.18))-0.38,0.0)*2.4;vec3 base=mix(vec3(0.04,0.04,0.07),vec3(0.22,0.2,0.28),den);base+=vec3(0.7,0.7,1.0)*fl*exp(-length(p.xy-flpos)*2.2)*den*2.5;col+=base*den*(1.0-alpha)*0.25;alpha+=den*(1.0-alpha)*0.2;if(alpha>0.95)break;}col+=vec3(0.5,0.5,0.8)*fl*0.12;col=mix(vec3(0.02,0.02,0.05),col,clamp(alpha+0.2,0.0,1.0));outColor=vec4(col*u_intensity,1.0);}
