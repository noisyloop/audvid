// name: PRISM REFRACT
// category: light
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;float a=atan(p.y,p.x);float r=length(p);vec3 col=vec3(0.0);for(float i=0.0;i<7.0;i++){float hue=i/7.0;float offset=hue*0.1;float ra=r+offset-0.3;float aa=a+sin(t+i)*0.5;vec2 pp=vec2(cos(aa),sin(aa))*ra;float prism=smoothstep(0.3,0.28,abs(ra))*smoothstep(0.0,0.1,ra+0.3);float beam=0.01/(abs(pp.y)+0.01)*smoothstep(0.0,0.2,pp.x)*(prism*0.5+smoothstep(-0.1,0.3,ra));col+=(0.5+0.5*cos(6.28318*(hue+vec3(0.0,0.33,0.67))))*beam*0.3*u_intensity;}col+=vec3(1.0)*smoothstep(0.35,0.0,r)*0.3;outColor=vec4(audioPop(col),1.0);}
