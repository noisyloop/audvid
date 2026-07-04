// name: PIXEL SORT
// category: glitch
// ported from prism-video-synth
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;float t=u_time*u_speed;float columns=40.0*u_scale;float col_id=floor(uv.x*columns);float h=hash(vec2(col_id,floor(t)));float sortHeight=h*0.8+0.1;float sortOffset=sin(t*2.0+col_id*0.5)*0.1;vec2 sortedUV=uv;if(uv.y<sortHeight+sortOffset)sortedUV.y=mod(uv.y+t*h*2.0,sortHeight+sortOffset);vec3 col=0.5+0.5*cos(sortedUV.y*10.0+t+vec3(0.0,2.0,4.0));col*=0.5+0.5*sin(sortedUV.x*columns*3.14159);col=mix(col,1.0-col,step(0.98,hash(vec2(col_id,floor(t*10.0)))));outColor=vec4(col*u_intensity,1.0);}
