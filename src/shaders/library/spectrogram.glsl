// name: SPECTROGRAM
// category: audio
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1.0,0.0)),f.x),mix(hash(i+vec2(0.0,1.0)),hash(i+vec2(1.0,1.0)),f.x),f.y);}
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;float t=u_time*u_speed;float freq=uv.y*16.0*u_scale;float time=uv.x*6.0+t*1.4;float e=sn(vec2(time*1.2,freq*0.5))*0.7+sn(vec2(time*3.1,freq*0.23))*0.3;e*=smoothstep(16.0,2.0,freq)*0.8+0.2;float harm=0.3*pow(0.5+0.5*sin(freq*3.5-time*0.8),4.0);e+=harm*sn(vec2(time*2.0,1.0));float beat=pow(0.5+0.5*sin(time*3.14159),8.0)*smoothstep(4.0,0.5,freq);e=clamp(e+beat*0.5,0.0,1.0);vec3 col=vec3(0.02,0.0,0.05);col=mix(col,vec3(0.25,0.0,0.4),smoothstep(0.15,0.4,e));col=mix(col,vec3(0.9,0.2,0.1),smoothstep(0.4,0.65,e));col=mix(col,vec3(1.0,0.85,0.3),smoothstep(0.65,0.85,e));col=mix(col,vec3(1.0),smoothstep(0.85,1.0,e));col*=0.92+0.08*sin(uv.y*u_res.y*2.0);outColor=vec4(col*u_intensity,1.0);}
