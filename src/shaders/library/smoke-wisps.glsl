// name: SMOKE WISPS
// category: organic
// ported from prism-video-synth
float noise(vec2 p){return fract(sin(dot(p,vec2(12.9898,78.233)))*43758.5453);}float sn(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(noise(i),noise(i+vec2(1.0,0.0)),f.x),mix(noise(i+vec2(0.0,1.0)),noise(i+vec2(1.0,1.0)),f.x),f.y);}float fbm(vec2 p){float v=0.0,a=0.5;for(int i=0;i<6;i++){v+=a*sn(p);p*=2.0;a*=0.5;}return v;}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=uv*3.0*u_scale;float t=u_time*u_speed*0.3;vec2 q=vec2(fbm(p+t),fbm(p+1.0));float smoke=fbm(p+q*2.0);smoke=pow(smoke,1.5);vec3 col=mix(vec3(0.02,0.02,0.05),vec3(0.3,0.3,0.4),smoke);col=mix(col,vec3(0.8,0.7,0.6),pow(smoke,3.0));outColor=vec4(audioPop(col*u_intensity),1.0);}
