// name: DUCKS FRACTAL
// category: fractal
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*2.2*u_scale+vec2(0.0,-0.3);vec2 c=vec2(-0.62+0.1*sin(t*0.21),0.78+0.1*cos(t*0.27));float acc=0.0;for(int i=0;i<22;i++){p=vec2(p.x,abs(p.y));p=vec2(0.5*log(max(dot(p,p),1e-9)),atan(p.y,p.x))+c;acc+=exp(-length(p)*1.2);}acc*=0.16;vec3 col=0.5+0.5*cos(6.28318*(acc+t*0.05+vec3(0.0,0.4,0.7)));col*=acc*1.4;col+=vec3(0.7,0.3,0.9)*pow(acc,3.0)*0.8;outColor=vec4(audioPop(col*u_intensity),1.0);}
