// name: RIPPLE POND
// category: nature
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;float ripple=0.0;for(float i=0.0;i<5.0;i++){vec2 center=vec2(sin(t*0.5+i*1.3),cos(t*0.4+i*1.7))*0.3;float d=length(p-center);ripple+=sin(d*30.0-t*3.0)*0.1/(d+0.3);}vec3 col=vec3(0.0,0.2,0.4)+vec3(0.2,0.5,0.7)*(ripple+0.5)+vec3(1.0)*pow(max(ripple,0.0),3.0)*u_intensity;outColor=vec4(col*u_intensity,1.0);}
