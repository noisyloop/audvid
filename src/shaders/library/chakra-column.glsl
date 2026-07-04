// name: CHAKRA COLUMN
// category: sacred
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*1.15*u_scale;vec3 col=vec3(0.01,0.0,0.03);float stream=exp(-abs(p.x+0.025*sin(p.y*6.0+t*2.0))*28.0)*(0.5+0.5*sin(p.y*12.0-t*3.5));col+=vec3(0.9,0.95,1.0)*max(stream,0.0)*0.5;for(int i=0;i<7;i++){float fi=float(i);vec2 c=vec2(0.0,(fi/3.0-1.0)*0.78);vec2 q=p-c;float r=length(q);float a=atan(q.y,q.x);float n=3.0+fi;float breathe=0.8+0.2*sin(t*1.2+fi*0.9);float lotus=abs(r-0.085*breathe*(1.0+0.3*cos(a*n+t*(0.4+fi*0.1))));float hue=fi*0.111;vec3 cc=0.5+0.5*cos(6.28318*(hue+vec3(0.0,0.33,0.67)));col+=cc*(smoothstep(0.012,0.0,lotus)+exp(-r*9.0)*0.45)*breathe;}outColor=vec4(audioPop(col*u_intensity),1.0);}
