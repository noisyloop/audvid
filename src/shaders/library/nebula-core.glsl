// name: NEBULA CORE
// category: volumetric
// ported from prism-video-synth
float hash3(vec3 p){return fract(sin(dot(p,vec3(127.1,311.7,74.7)))*43758.5453);}
float n3(vec3 p){vec3 i=floor(p);vec3 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(mix(hash3(i),hash3(i+vec3(1,0,0)),f.x),mix(hash3(i+vec3(0,1,0)),hash3(i+vec3(1,1,0)),f.x),f.y),mix(mix(hash3(i+vec3(0,0,1)),hash3(i+vec3(1,0,1)),f.x),mix(hash3(i+vec3(0,1,1)),hash3(i+vec3(1,1,1)),f.x),f.y),f.z);}
float fbm3(vec3 p){float v=0.0,a=0.5;for(int i=0;i<4;i++){v+=a*n3(p);p*=2.1;a*=0.5;}return v;}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed*0.3;vec3 ro=vec3(0.0,0.0,2.4);vec3 rd=normalize(vec3(uv,-1.4));float ca=t*0.3;mat3 m=mat3(cos(ca),0,sin(ca),0,1,0,-sin(ca),0,cos(ca));ro=m*ro;rd=m*rd;vec3 col=vec3(0.0);float alpha=0.0;for(int i=0;i<44;i++){vec3 p=ro+rd*(float(i)*0.09+0.4);float r=length(p);float den=max(fbm3(p*1.3*u_scale+vec3(t*0.5,t*0.3,-t*0.4))-0.42,0.0)*2.2;den*=exp(-r*0.7);float hue=r*0.45+den*0.6-t*0.15;vec3 c=(0.5+0.5*cos(6.28318*(hue+vec3(0.0,0.33,0.67))))*den;col+=c*(1.0-alpha)*0.22;alpha+=den*(1.0-alpha)*0.16;col+=vec3(1.0,0.85,0.6)*exp(-r*4.5)*0.01*(1.0-alpha);if(alpha>0.95)break;}outColor=vec4(col*u_intensity,1.0);}
