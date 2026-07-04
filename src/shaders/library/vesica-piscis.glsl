// name: VESICA PISCIS
// category: sacred
// ported from prism-video-synth
float circle(vec2 p,vec2 c,float r){return abs(length(p-c)-r);}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*4.0*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed*0.2;float r=0.8;float v=0.0;float N=7.0;for(float i=0.0;i<7.0;i++){float ang=i/7.0*6.28318+t*0.1;vec2 c=vec2(cos(ang),sin(ang))*r*0.5;v+=smoothstep(0.03,0.0,circle(p,c,r));}float pulse=sin(length(p)*5.0-t*2.0)*0.4+0.6;float hue=atan(p.y,p.x)/6.28318+t*0.15;vec3 col=(0.5+0.5*cos(hue*6.28318*2.0+vec3(0.0,2.09,4.18)))*v*pulse;col+=vec3(0.1,0.0,0.2)*(sin(length(p)*10.0+t)*0.5+0.5)*(1.0-min(v,1.0));outColor=vec4(audioPop(col*u_intensity),1.0);}
