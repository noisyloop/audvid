// name: CANTOR VEIL
// category: fractal
// ported from prism-video-synth
void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;float t=u_time*u_speed;vec3 col=vec3(0.01,0.0,0.03);for(int L=0;L<4;L++){float fl=float(L);float x=(uv.x+sin(uv.y*2.5+t*(0.3+fl*0.1))*0.04)*u_scale*pow(2.0,fl)+t*0.05*(fl+1.0);float v=1.0;for(int j=0;j<5;j++){float f=fract(x);v*=smoothstep(0.0,0.045,abs(f-0.5)-0.1667);x*=3.0;}float band=smoothstep(0.0,0.15,uv.y)*smoothstep(1.0,0.55-fl*0.1,uv.y);col+=(0.5+0.5*cos(6.28318*(fl*0.22+t*0.06+vec3(0.0,0.33,0.67))))*v*band*(0.55-fl*0.1);}outColor=vec4(audioPop(col*u_intensity),1.0);}
