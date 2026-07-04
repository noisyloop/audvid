// name: WORMHOLE
// category: space
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;float r=length(p);float a=atan(p.y,p.x);float warp=1.0/(r+0.1);float spiral=sin(a*5.0+warp*3.0-t*2.0);vec3 col=vec3(0.0);float tunnel=smoothstep(0.0,0.5,r)*smoothstep(1.0,0.3,r);col+=(0.5+0.5*cos(warp+t+vec3(0.0,2.0,4.0)))*tunnel*(spiral*0.5+0.5)*u_intensity;col=mix(col,vec3(0.0),smoothstep(0.15,0.0,r));col+=vec3(1.0,0.5,0.2)*smoothstep(0.02,0.0,abs(r-0.15))*u_intensity;outColor=vec4(col,1.0);}
