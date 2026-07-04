// name: OCEAN DEPTH
// category: nature
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=uv-0.5;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;vec3 col=mix(vec3(0.0,0.1,0.2),vec3(0.0,0.05,0.1),uv.y);for(float i=0.0;i<3.0;i++){vec2 q=p*(2.0+i)*u_scale+t*0.5;float c=abs(sin(q.x*3.0+sin(q.y*2.0+t))+sin(q.y*3.0+sin(q.x*2.0-t*0.7)));col+=vec3(0.1,0.3,0.4)*pow(0.1/c,1.5)*(1.0-i*0.2)*u_intensity;}float rays=0.0;for(float i=0.0;i<5.0;i++){float x=sin(i*1.5+t*0.2)*0.5;rays+=smoothstep(0.1,0.0,abs(p.x-x))*smoothstep(0.0,0.5,uv.y)*0.1;}col+=vec3(0.2,0.4,0.5)*rays*u_intensity;outColor=vec4(col,1.0);}
