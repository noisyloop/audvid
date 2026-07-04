// name: LIQUID METAL
// category: organic
// ported from prism-video-synth
float noise(vec2 p){return fract(sin(dot(p,vec2(12.9898,78.233)))*43758.5453);}float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(noise(i),noise(i+vec2(1.0,0.0)),f.x),mix(noise(i+vec2(0.0,1.0)),noise(i+vec2(1.0,1.0)),f.x),f.y);}float fbm(vec2 p){float v=0.0;float a=0.5;for(int i=0;i<6;i++){v+=a*sn(p);p*=2.0;a*=0.5;}return v;}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=uv*3.0*u_scale;float t=u_time*u_speed;float n=fbm(p+fbm(p+fbm(p+t)));vec3 col=mix(vec3(0.1,0.1,0.3),vec3(0.8,0.8,1.0),n);col=mix(col,vec3(1.0,0.9,0.7),pow(n,3.0));col+=0.3*vec3(0.5,0.7,1.0)*pow(n,5.0);outColor=vec4(col*u_intensity,1.0);}
