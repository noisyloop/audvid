// name: LAVA LAMP
// category: organic
// ported from prism-video-synth
float meta(vec2 p,vec2 c,float r){return r*r/dot(p-c,p-c);}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*2.0*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed*0.3;float m=0.0;for(float i=0.0;i<8.0;i++){float phase=i*0.8+t;vec2 c=vec2(sin(phase*0.7)*0.4,sin(phase)*0.6-0.2+i*0.15);m+=meta(p,c,0.15+0.05*sin(t+i));}vec3 col=vec3(0.1,0.0,0.05);float blob=smoothstep(0.8,1.2,m);col=mix(col,vec3(1.0,0.2,0.1),blob);col=mix(col,vec3(1.0,0.8,0.2),smoothstep(1.5,3.0,m));col+=vec3(0.3,0.0,0.1)*(1.0-uv.y)*0.5;outColor=vec4(col*u_intensity,1.0);}
