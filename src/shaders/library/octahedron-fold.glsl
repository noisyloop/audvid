// name: OCTAHEDRON FOLD
// category: 3d
// ported from prism-video-synth
mat3 rotY(float a){float c=cos(a),s=sin(a);return mat3(c,0,s,0,1,0,-s,0,c);}
mat3 rotX(float a){float c=cos(a),s=sin(a);return mat3(1,0,0,0,c,-s,0,s,c);}
float de(vec3 p,float t){p/=u_scale;float s=1.0;vec3 off=vec3(1.0,0.62,0.3)*(1.0+0.08*sin(t*0.4));for(int i=0;i<6;i++){p=abs(p);if(p.x<p.y)p.xy=p.yx;if(p.x<p.z)p.xz=p.zx;if(p.y<p.z)p.yz=p.zy;p=p*2.0-off;s*=2.0;}return (length(p)-1.4)/s*u_scale;}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed*0.4;mat3 m=rotY(t*0.6)*rotX(t*0.37);vec3 ro=m*vec3(0.0,0.0,2.8);vec3 rd=m*normalize(vec3(uv,-1.5));float d=0.0;vec3 p=ro;float it=0.0;bool hit=false;for(int i=0;i<80;i++){float s=de(p,t);if(s<0.0018){hit=true;break;}d+=s;p=ro+rd*d;it+=1.0;if(d>7.0)break;}vec3 col=vec3(0.02,0.01,0.04);if(hit){float eps=0.003;vec3 n=normalize(vec3(de(p+vec3(eps,0,0),t)-de(p-vec3(eps,0,0),t),de(p+vec3(0,eps,0),t)-de(p-vec3(0,eps,0),t),de(p+vec3(0,0,eps),t)-de(p-vec3(0,0,eps),t)));float diff=max(dot(n,normalize(vec3(1,2,1))),0.0);float ao=1.0-it/80.0;float hue=d*0.25+p.y*0.3+t*0.2;col=(0.5+0.5*cos(6.28318*(hue+vec3(0.0,0.33,0.67))))*(diff*0.7+0.2)*ao;col+=vec3(1.0,0.5,0.8)*pow(1.0-max(dot(n,-rd),0.0),3.0)*0.4;}outColor=vec4(audioPop(col*u_intensity),1.0);}
