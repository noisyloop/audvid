// name: BURNING SHIP
// category: fractal
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;float zm=pow(2.0,-mod(t*0.4,8.0))*2.6*u_scale;vec2 c=vec2(-1.7533,-0.0257)+vec2(uv.x,-uv.y)*zm;vec2 z=vec2(0.0);float it=0.0;for(int i=0;i<90;i++){z=abs(z);z=vec2(z.x*z.x-z.y*z.y,2.0*z.x*z.y)+c;if(dot(z,z)>16.0)break;it+=1.0;}float si=it-log2(log2(max(dot(z,z),1.0001)))+4.0;float inside=step(89.5,it);vec3 col=(0.5+0.5*cos(6.28318*(si*0.045+t*0.08+vec3(0.0,0.35,0.7))))*(1.0-inside);col+=vec3(1.0,0.6,0.2)*exp(-si*0.18)*(1.0-inside);outColor=vec4(col*u_intensity,1.0);}
