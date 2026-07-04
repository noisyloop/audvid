// name: DATA STREAM 3D
// category: cyber
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec3 col=vec3(0.0,0.01,0.03);for(int L=0;L<4;L++){float fl=float(L);float z=1.0+fl*1.4;vec2 p=uv*z*u_scale;p.y+=t*(1.6-fl*0.25);float lanes=9.0;float lane=floor(p.x*lanes);float fy=floor(p.y*7.0);float h=hash(vec2(lane,fy));float on=step(0.45,hash(vec2(lane,fy+floor(fl*7.0))));vec2 cell=vec2(fract(p.x*lanes),fract(p.y*7.0));float block=smoothstep(0.45,0.35,abs(cell.x-0.5))*smoothstep(0.48,0.38,abs(cell.y-0.5))*on;float fade=1.0/(z*1.1);float flicker=0.7+0.3*sin(t*9.0+h*40.0);vec3 cc=mix(vec3(0.0,0.9,0.6),vec3(0.3,0.6,1.0),hash(vec2(lane,fl)));col+=cc*block*fade*flicker*(0.4+h*0.6);col+=cc*smoothstep(0.06,0.0,abs(fract(p.x*lanes)-0.5))*0.05*fade;}col*=0.9+0.1*sin(uv.y*u_res.y*1.5);outColor=vec4(col*u_intensity,1.0);}
