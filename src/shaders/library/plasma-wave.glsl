// name: PLASMA WAVE
// category: organic
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv*2.0-1.0)*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;float v=sin(p.x*10.0+t)+sin((p.y*10.0+t)*0.5)+sin((p.x*10.0+p.y*10.0+t)*0.5)+sin(sqrt(p.x*p.x+p.y*p.y)*10.0+t);vec3 col=vec3(sin(v*3.14159+t)*0.5+0.5,sin(v*3.14159+t+2.094)*0.5+0.5,sin(v*3.14159+t+4.188)*0.5+0.5)*u_intensity;outColor=vec4(audioPop(col),1.0);}
