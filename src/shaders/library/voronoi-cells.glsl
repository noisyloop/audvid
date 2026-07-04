// name: VORONOI CELLS
// category: geometric
// ported from prism-video-synth
vec2 hash2(vec2 p){return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=uv*5.0*u_scale;float t=u_time*u_speed;vec2 n=floor(p);vec2 f=fract(p);float md=8.0;for(int j=-1;j<=1;j++)for(int i=-1;i<=1;i++){vec2 g=vec2(float(i),float(j));vec2 o=hash2(n+g);o=0.5+0.5*sin(t+6.2831*o);float d=dot(g+o-f,g+o-f);if(d<md)md=d;}vec3 col=(0.5+0.5*cos(6.2831*md+vec3(0.0,1.0,2.0)+t))*(1.0-0.5*smoothstep(0.0,0.05,md))+vec3(1.0)*smoothstep(0.02,0.0,md-0.01);outColor=vec4(col*u_intensity,1.0);}
