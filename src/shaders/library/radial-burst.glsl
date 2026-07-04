// name: RADIAL BURST
// category: energy
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=uv-0.5;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;float r=length(p)*u_scale;float a=atan(p.y,p.x);vec3 col=vec3(0.0);for(float i=0.0;i<12.0;i++){float offset=i*0.523599;float ray=pow(abs(sin(a*6.0+offset+t)),20.0);float radial=smoothstep(0.0,0.5,r)*smoothstep(1.0,0.3,r);float pulse=sin(r*10.0-t*3.0+i)*0.5+0.5;col+=(0.5+0.5*cos(i*0.5+t+vec3(0.0,2.0,4.0)))*ray*radial*pulse*u_intensity*0.3;}col+=vec3(1.0,0.9,0.8)*smoothstep(0.1,0.0,r)*0.5;outColor=vec4(audioPop(col),1.0);}
