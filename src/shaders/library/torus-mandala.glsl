// name: TORUS MANDALA
// category: sacred
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*4.0*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;float r=length(p);float a=atan(p.y,p.x);float petals=12.0;float mandala=0.0;for(float i=0.0;i<petals;i++){float pa=a-i*6.28318/petals+t*0.2;float pr=r-0.6+sin(pa*2.0+t)*0.15;mandala+=smoothstep(0.04,0.0,abs(pr))*smoothstep(3.14159,0.0,abs(pa-floor((pa+3.14159)/6.28318*petals)/petals*6.28318+3.14159/petals));}float rings=0.0;for(float i=1.0;i<5.0;i++){rings+=smoothstep(0.025,0.0,abs(r-i*0.28));}float v=mandala+rings*0.5;float hue=a/6.28318+r*0.2+t*0.1;vec3 col=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*v;col+=vec3(0.3,0.0,0.5)*smoothstep(0.3,0.0,r)*(1.0-v);outColor=vec4(col*u_intensity,1.0);}
