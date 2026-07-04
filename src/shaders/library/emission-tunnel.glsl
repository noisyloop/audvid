// name: EMISSION TUNNEL
// category: volumetric
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec3 ro=vec3(0.25*sin(t*0.7),0.25*cos(t*0.55),0.0);vec3 rd=normalize(vec3(uv,1.5));vec3 col=vec3(0.0);float d=0.1;for(int i=0;i<48;i++){vec3 p=ro+rd*d;p.z+=t*2.5;float ang=atan(p.y,p.x);float r=length(p.xy);float wall=1.0+0.18*sin(ang*5.0+p.z*1.2)+0.1*sin(p.z*2.0-t);float sd=abs(wall*u_scale-r);float rings=0.6+0.6*sin(p.z*3.5-t*5.0);float em=0.016/(sd+0.05)*rings;float hue=p.z*0.12+ang*0.1-t*0.2;col+=(0.5+0.5*cos(6.28318*(hue+vec3(0.0,0.33,0.67))))*em*exp(-d*0.22)*0.16;d+=0.16;if(d>9.0)break;}outColor=vec4(col*u_intensity,1.0);}
