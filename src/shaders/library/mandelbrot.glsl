// name: MANDELBROT
// category: fractal
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;float t=u_time*u_speed*0.1;float zoom=pow(2.0,-mod(t,10.0));vec2 c=vec2(-0.745,0.186)+(uv-0.5)*zoom*3.0*u_scale;c.x*=u_res.x/u_res.y;vec2 z=vec2(0.0);float iter=0.0;for(int i=0;i<100;i++){z=vec2(z.x*z.x-z.y*z.y,2.0*z.x*z.y)+c;if(dot(z,z)>4.0)break;iter+=1.0;}float si=iter-log2(log2(dot(z,z)));vec3 col=(0.5+0.5*cos(si*0.1+t+vec3(0.0,2.0,4.0)))*smoothstep(100.0,0.0,iter);outColor=vec4(audioPop(col*u_intensity),1.0);}
