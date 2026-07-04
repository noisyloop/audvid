// name: QUATERNION JULIA
// category: 3d
// ported from prism-video-synth
vec4 qmul(vec4 a,vec4 b){return vec4(a.x*b.x-dot(a.yzw,b.yzw),a.x*b.yzw+b.x*a.yzw+cross(a.yzw,b.yzw));}
mat3 rotY(float a){float c=cos(a),s=sin(a);return mat3(c,0,s,0,1,0,-s,0,c);}
float de(vec3 p,vec4 c){vec4 z=vec4(p/u_scale,0.0);float dr=1.0;for(int i=0;i<8;i++){dr=2.0*length(z)*dr;z=qmul(z,z)+c;if(dot(z,z)>16.0)break;}float r=length(z);return 0.5*r*log(max(r,1e-6))/max(dr,1e-6)*u_scale;}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec4 c=vec4(-0.2+0.25*sin(t*0.43),0.55+0.2*cos(t*0.31),0.2*sin(t*0.27),0.1*cos(t*0.5));mat3 m=rotY(t*0.25);vec3 ro=m*vec3(0.0,0.0,2.5);vec3 rd=m*normalize(vec3(uv,-1.5));float d=0.0;vec3 p=ro;bool hit=false;for(int i=0;i<70;i++){float s=de(p,c);if(s<0.002){hit=true;break;}d+=s;p=ro+rd*d;if(d>6.0)break;}vec3 col=vec3(0.02,0.0,0.04);if(hit){float eps=0.002;vec3 n=normalize(vec3(de(p+vec3(eps,0,0),c)-de(p-vec3(eps,0,0),c),de(p+vec3(0,eps,0),c)-de(p-vec3(0,eps,0),c),de(p+vec3(0,0,eps),c)-de(p-vec3(0,0,eps),c)));float diff=max(dot(n,normalize(vec3(1,2,1))),0.0);float hue=p.x*0.5+p.y*0.4+t*0.12;col=(0.5+0.5*cos(6.28318*(hue+vec3(0.0,0.33,0.67))))*(diff*0.75+0.18);col+=vec3(0.6,0.9,1.0)*pow(1.0-max(dot(n,-rd),0.0),4.0)*0.6;}outColor=vec4(audioPop(col*u_intensity),1.0);}
