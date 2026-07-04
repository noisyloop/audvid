// name: INFINITE LATTICE
// category: 3d
// ported from prism-video-synth
float sdFrame(vec3 p,vec3 b,float e){p=abs(p)-b;vec3 q=abs(p+e)-e;return min(min(length(max(vec3(p.x,q.y,q.z),0.0))+min(max(p.x,max(q.y,q.z)),0.0),length(max(vec3(q.x,p.y,q.z),0.0))+min(max(q.x,max(p.y,q.z)),0.0)),length(max(vec3(q.x,q.y,p.z),0.0))+min(max(q.x,max(q.y,p.z)),0.0));}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec3 ro=vec3(0.35*sin(t*0.3),0.35*cos(t*0.23),t*0.9);float ca=t*0.1;vec3 rd=normalize(vec3(uv,1.4));rd.xy=mat2(cos(ca),-sin(ca),sin(ca),cos(ca))*rd.xy;vec3 col=vec3(0.0);float d=0.05;for(int i=0;i<64;i++){vec3 p=ro+rd*d;vec3 q=mod(p,2.0)-1.0;float s=sdFrame(q,vec3(0.62*u_scale),0.045);float em=exp(-abs(s)*30.0);float hue=floor(p.z*0.5)*0.11+t*0.1;col+=(0.5+0.5*cos(6.28318*(hue+vec3(0.0,0.33,0.67))))*em*exp(-d*0.35)*0.09;d+=max(abs(s)*0.7,0.02);if(d>16.0)break;}outColor=vec4(col*u_intensity,1.0);}
