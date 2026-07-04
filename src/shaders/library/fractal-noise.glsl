// name: FRACTAL NOISE
// category: organic
// ported from prism-video-synth
float noise(vec2 p){return fract(sin(dot(p,vec2(12.9898,78.233)))*43758.5453);}float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(noise(i),noise(i+vec2(1.0,0.0)),f.x),mix(noise(i+vec2(0.0,1.0)),noise(i+vec2(1.0,1.0)),f.x),f.y);}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=uv*4.0*u_scale;float t=u_time*u_speed;float n=0.0,a=0.5,f=1.0;for(int i=0;i<8;i++){n+=a*sn(p*f+t);f*=2.0;a*=0.5;}vec3 col=0.5+0.5*cos(n*6.28318+t+vec3(0.0,2.0,4.0));outColor=vec4(audioPop(col*u_intensity),1.0);}
