// name: FRACTAL TUNNEL
// category: geometric
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*u_scale;p.x*=u_res.x/u_res.y;float a=atan(p.y,p.x);float r=length(p);float t=u_time*u_speed;float z=fract(1.0/r-t);float spiral=fract(a/6.28318+t*0.1+z*2.0);vec3 col=(0.5+0.5*cos(6.28318*(z+vec3(0.0,0.33,0.67))))*smoothstep(0.0,0.02,abs(spiral-0.5)-0.2)*z*2.0*u_intensity;col+=0.1*vec3(0.3,0.1,0.5)/r;outColor=vec4(col,1.0);}
