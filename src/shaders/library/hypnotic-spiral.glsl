// name: HYPNOTIC SPIRAL
// category: psychedelic
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;float a=atan(p.y,p.x);float r=length(p);float spiral=smoothstep(-0.5,0.5,sin(a*5.0+r*20.0-t*3.0));float pulse=sin(r*10.0-t*2.0)*0.5+0.5;vec3 col=mix(vec3(0.1,0.0,0.2),vec3(0.9,0.3,0.8),spiral);col=mix(col,vec3(0.2,0.8,1.0),pulse*spiral*0.5);col+=vec3(1.0,0.8,0.9)*smoothstep(0.3,0.0,r);col*=(1.0-r*0.5)*u_intensity;outColor=vec4(audioPop(col),1.0);}
