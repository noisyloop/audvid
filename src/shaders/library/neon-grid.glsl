// name: NEON GRID
// category: retro
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=uv-0.5;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;float z=1.0/(1.0-uv.y+0.1);vec2 gp=vec2(p.x*z,z-t*5.0)*u_scale;vec2 g=abs(fract(gp*0.5-0.5)-0.5)/fwidth(gp*0.5);float line=1.0-min(min(g.x,g.y),1.0);vec3 col=vec3(1.0,0.0,0.5)*line*0.5*u_intensity+vec3(0.0,1.0,1.0)*line*smoothstep(0.8,0.2,uv.y)*u_intensity+vec3(0.1,0.0,0.2)*(1.0-uv.y);float sun=smoothstep(0.3,0.28,length(p-vec2(0.0,0.2)));col+=vec3(1.0,0.3,0.1)*sun+vec3(1.0,0.8,0.0)*smoothstep(0.28,0.1,length(p-vec2(0.0,0.2)));outColor=vec4(audioPop(col),1.0);}
