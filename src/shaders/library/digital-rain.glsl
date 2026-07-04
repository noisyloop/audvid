// name: DIGITAL RAIN
// category: cyber
// ported from prism-video-synth
float hash(float n){return fract(sin(n)*43758.5453);}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;float t=u_time*u_speed;vec3 col=vec3(0.0,0.02,0.01);for(float layer=0.0;layer<3.0;layer++){float density=30.0+layer*20.0;density*=u_scale;float speed=0.5+layer*0.2;vec2 p=uv*vec2(density,1.0);vec2 id=floor(p);vec2 f=fract(p);float h=hash(id.x);float drop=fract(h+t*speed*(0.5+h*0.5));drop=smoothstep(0.0,0.1,drop)*smoothstep(1.0,0.9,drop);float y=fract(f.y-t*speed*(0.5+h*0.5));float trail=smoothstep(0.0,0.3,y)*smoothstep(1.0,0.5,y);float r=drop*trail*smoothstep(0.4,0.5,abs(f.x-0.5));col+=vec3(0.0,1.0,0.3)*r*(0.8-layer*0.2)*u_intensity;}col*=0.9+0.1*sin(uv.y*u_res.y*2.0);outColor=vec4(audioPop(col),1.0);}
