// name: STARGATE
// category: space
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;float r=length(p);float a=atan(p.y,p.x);vec3 col=vec3(0.0);for(float i=0.0;i<10.0;i++){float fi=i/10.0;float z=fract(fi-t*0.5);float size=mix(0.5,0.01,z);float ring=smoothstep(size+0.02,size,r)*smoothstep(size-0.02,size,r);float seg=step(0.5,fract(a*3.0/6.28318+fi+t*0.2));col+=(0.5+0.5*cos(fi*6.28318+t+vec3(0.0,2.0,4.0)))*ring*seg*z*u_intensity;}col+=vec3(0.5,0.7,1.0)*smoothstep(0.1,0.0,r)*0.5;outColor=vec4(audioPop(col),1.0);}
