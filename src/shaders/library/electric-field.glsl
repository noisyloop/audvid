// name: ELECTRIC FIELD
// category: energy
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;vec3 col=vec3(0.0);for(float i=0.0;i<8.0;i++){vec2 c1=vec2(sin(t+i),cos(t*0.7+i))*0.3;vec2 c2=vec2(sin(t*0.8+i+3.0),cos(t*0.6+i+3.0))*0.3;vec2 field=(p-c1)/dot(p-c1,p-c1)-(p-c2)/dot(p-c2,p-c2);float strength=length(field);col+=(0.5+0.5*cos(i*0.8+t+vec3(0.0,2.0,4.0)))*0.02/(strength+0.1)*u_intensity;}outColor=vec4(col,1.0);}
