// name: CRYSTAL MATRIX
// category: geometric
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*10.0*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;vec3 col=vec3(0.02,0.02,0.05);for(float i=0.0;i<6.0;i++){float angle=i*1.047198+t*0.2;vec2 dir=vec2(cos(angle),sin(angle));float line=abs(dot(p,dir));line=sin(line*3.14159)*0.5+0.5;col+=(0.5+0.5*cos(i+t+vec3(0.0,2.0,4.0)))*pow(line,8.0)*u_intensity*0.3;}col+=vec3(1.0,0.9,0.95)*smoothstep(0.5,0.0,length(p/u_scale))*0.3;outColor=vec4(audioPop(col),1.0);}
