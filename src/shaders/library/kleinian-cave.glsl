// name: KLEINIAN CAVE
// category: 3d
// ported from prism-video-synth
float de(vec3 p){float s=1.0;for(int i=0;i<7;i++){p=-1.0+2.0*fract(0.5*p+0.5);float r2=max(dot(p,p),1e-4);float k=1.15/r2;p*=k;s*=k;}return 0.25*abs(p.y)/s;}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec3 ro=vec3(t*0.18,0.12*sin(t*0.4),t*0.13);vec3 rd=normalize(vec3(uv*u_scale,-1.3));float ca=t*0.07;rd=mat3(cos(ca),0,sin(ca),0,1,0,-sin(ca),0,cos(ca))*rd;float d=0.01;vec3 p=ro;float it=0.0;bool hit=false;for(int i=0;i<80;i++){float s=de(p);if(s<0.0012){hit=true;break;}d+=s*0.8;p=ro+rd*d;it+=1.0;if(d>7.0)break;}vec3 col=vec3(0.01,0.0,0.02);if(hit){float ao=1.0-it/80.0;float hue=p.x*0.3+p.z*0.3+d*0.2+t*0.05;col=(0.5+0.5*cos(6.28318*(hue+vec3(0.0,0.33,0.67))))*ao*ao*1.3;col+=vec3(0.9,0.6,1.0)*exp(-d*0.8)*0.25;}col=mix(col,vec3(0.02,0.0,0.05),clamp(d/7.0,0.0,1.0));outColor=vec4(col*u_intensity,1.0);}
