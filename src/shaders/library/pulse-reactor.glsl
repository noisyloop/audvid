// name: PULSE REACTOR
// category: 3d
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec3 ro=vec3(0.0,0.0,2.6);vec3 rd=normalize(vec3(uv,-1.4));float ca=t*0.22;mat3 m=mat3(cos(ca),0,sin(ca),0,1,0,-sin(ca),0,cos(ca));ro=m*ro;rd=m*rd;vec3 col=vec3(0.0);float d=0.3;for(int i=0;i<48;i++){vec3 p=ro+rd*d;float r=length(p);float g=dot(sin(p*3.0*u_scale+t*0.5),cos(p.yzx*3.0*u_scale-t*0.3))*0.12;float sd=r-(0.75+0.22*sin(t*2.0-r*4.5))*u_scale+g;float em=0.018/(abs(sd)+0.045);float hue=r*0.5-t*0.25;col+=(0.5+0.5*cos(6.28318*(hue+vec3(0.0,0.33,0.67))))*em*0.06;col+=vec3(1.0,0.7,0.3)*exp(-r*3.0)*0.012;d+=0.075;if(d>5.0)break;}outColor=vec4(col*u_intensity,1.0);}
