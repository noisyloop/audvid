// name: TRI MORPH TILES
// category: tiling
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*5.0*u_scale;p.x+=t*0.15;vec2 q=vec2(p.x+p.y*0.57735,p.y*1.1547);vec2 id=floor(q);vec2 f=fract(q);float up=step(1.0,f.x+f.y);float e=up<0.5?min(min(f.x,f.y),1.0-f.x-f.y):min(min(1.0-f.x,1.0-f.y),f.x+f.y-1.0);float h=hash(id+up*0.37);float pulse=0.5+0.5*sin(t*1.8+h*6.28318);float hue=h*0.4+up*0.12+t*0.07;vec3 col=(0.5+0.5*cos(6.28318*(hue+vec3(0.0,0.33,0.67))))*(0.25+0.75*pulse)*smoothstep(0.0,0.06,e);col+=vec3(1.0,0.95,0.9)*smoothstep(0.05,0.0,e)*pulse*0.45;outColor=vec4(audioPop(col*u_intensity),1.0);}
