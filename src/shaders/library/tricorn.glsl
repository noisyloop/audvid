// name: TRICORN
// category: fractal
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 z=uv*1.9*u_scale;vec2 c=0.62*vec2(cos(t*0.31),sin(t*0.43));float it=0.0;for(int i=0;i<70;i++){z=vec2(z.x*z.x-z.y*z.y,-2.0*z.x*z.y)+c;if(dot(z,z)>9.0)break;it+=1.0;}float si=it-log2(log2(max(dot(z,z),1.0001)))+4.0;float inside=step(69.5,it);vec3 col=(0.5+0.5*cos(6.28318*(si*0.06+t*0.1+vec3(0.0,0.25,0.55))))*(1.0-inside);col+=vec3(0.12,0.05,0.2)*inside*(0.5+0.5*sin(length(z)*20.0+t*2.0));outColor=vec4(col*u_intensity,1.0);}
