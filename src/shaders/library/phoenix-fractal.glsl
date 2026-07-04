// name: PHOENIX FRACTAL
// category: fractal
// ported from prism-video-synth
vec2 cmul(vec2 a,vec2 b){return vec2(a.x*b.x-a.y*b.y,a.x*b.y+a.y*b.x);}void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 z=vec2(uv.y,uv.x)*1.8*u_scale;vec2 zp=vec2(0.0);float cr=0.5667+0.04*sin(t*0.33);float pr=-0.5+0.04*cos(t*0.41);float it=0.0;for(int i=0;i<60;i++){vec2 nz=cmul(z,z)+vec2(cr,0.0)+pr*zp;zp=z;z=nz;if(dot(z,z)>16.0)break;it+=1.0;}float si=it-log2(log2(max(dot(z,z),1.0001)))+4.0;float inside=step(59.5,it);vec3 col=(0.5+0.5*cos(6.28318*(si*0.05+t*0.07+vec3(0.0,0.33,0.67))))*(1.0-inside);col+=(0.5+0.5*cos(6.28318*(length(zp)*0.3+vec3(0.5,0.8,1.1))))*inside*0.3;outColor=vec4(audioPop(col*u_intensity),1.0);}
