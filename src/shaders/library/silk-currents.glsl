// name: SILK CURRENTS
// category: flow
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 q=uv*2.0*u_scale;for(int i=0;i<5;i++){float fi=float(i);q=vec2(q.x+0.55*sin(q.y*1.4+t*0.4+fi*1.7),q.y+0.55*cos(q.x*1.2-t*0.33+fi*2.3));}float v=sin(q.x*1.6)+sin(q.y*1.8);float sheen=pow(0.5+0.5*sin(q.x+q.y-t*0.5),7.0);vec3 col=(0.5+0.5*cos(6.28318*(v*0.13+t*0.04+vec3(0.0,0.33,0.67))))*(0.4+0.3*v*0.5+0.3);col+=vec3(1.0,0.97,0.92)*sheen*0.75;col*=0.85+0.15*sin(q.y*3.0);outColor=vec4(col*u_intensity,1.0);}
