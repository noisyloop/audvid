// name: CIRCUIT BOARD
// category: cyber
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=uv*20.0*u_scale;float t=u_time*u_speed;vec2 id=floor(p);vec2 f=fract(p);float h=hash(id);vec3 col=vec3(0.0,0.05,0.02);float trace=h>0.5?smoothstep(0.1,0.0,abs(f.x-0.5)):smoothstep(0.1,0.0,abs(f.y-0.5));float node=smoothstep(0.15,0.1,length(f-0.5));float pulse=sin(t*3.0+h*10.0)*0.5+0.5;col+=vec3(0.0,0.8,0.3)*trace*0.5*u_intensity+vec3(0.0,1.0,0.5)*node*pulse*u_intensity+vec3(0.0,0.3,0.1)*(1.0-length(uv-0.5))*0.3;outColor=vec4(audioPop(col),1.0);}
