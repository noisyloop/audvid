// name: GOLDEN SPIRAL
// category: sacred
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*5.0*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed*0.3;float r=length(p);float a=atan(p.y,p.x)+t;float phi=1.61803398875;float logSpiral=log(r)/log(phi)-a/6.28318*log(phi);float spiral=fract(logSpiral);float v=smoothstep(0.1,0.0,abs(spiral-0.5)-0.4)*smoothstep(0.0,0.5,r);float shells=0.0;for(float i=0.0;i<6.0;i++){float sr=pow(phi,i)*0.05;shells+=smoothstep(0.015,0.0,abs(r-sr));}float hue=spiral+t*0.1;vec3 col=(0.5+0.5*cos(hue*6.28318+vec3(0.0,2.09,4.18)))*(v+shells);col+=vec3(0.8,0.6,0.1)*shells;outColor=vec4(audioPop(col*u_intensity),1.0);}
