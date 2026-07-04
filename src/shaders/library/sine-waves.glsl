// name: SINE WAVES
// category: audio
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;float v=0.0;for(float i=0.0;i<8.0;i++){float angle=i*0.785398;vec2 dir=vec2(cos(angle),sin(angle));v+=sin(dot(p,dir)*20.0+t*(1.0+i*0.2));}v=v/8.0;vec3 col=0.5+0.5*cos(v*3.0+t+vec3(0.0,2.0,4.0));col*=0.8+0.2*v;outColor=vec4(audioPop(col*u_intensity),1.0);}
