// name: HEX GRID
// category: geometric
// ported from prism-video-synth
vec2 hexCenter(vec2 p){vec2 a=mod(p,2.0)-1.0;vec2 b=mod(p+1.0,2.0)-1.0;return dot(a,a)<dot(b,b)?a:b;}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*10.0*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;vec2 h=hexCenter(p);float d=length(h);float pulse=sin(d*3.0-t*2.0)*0.5+0.5;vec3 col=0.5+0.5*cos(d*2.0+t+vec3(0.0,2.0,4.0));col*=smoothstep(0.5,0.4,d);col+=vec3(1.0)*smoothstep(0.02,0.0,abs(d-0.4))*pulse*u_intensity;col*=0.5+0.5*pulse;outColor=vec4(col*u_intensity,1.0);}
