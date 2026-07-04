// name: JULIA SET
// category: fractal
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;float t=u_time*u_speed*0.2;vec2 z=(uv-0.5)*3.0*u_scale;z.x*=u_res.x/u_res.y;vec2 c=vec2(sin(t)*0.7,cos(t*0.7)*0.5);float iter=0.0;for(int i=0;i<100;i++){z=vec2(z.x*z.x-z.y*z.y,2.0*z.x*z.y)+c;if(dot(z,z)>4.0)break;iter+=1.0;}vec3 col=(0.5+0.5*cos(iter*0.15+t+vec3(0.0,2.0,4.0)))*smoothstep(100.0,0.0,iter);outColor=vec4(audioPop(col*u_intensity),1.0);}
