// name: DIFFRACTION STAR
// category: light
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*1.5*u_scale;float r=length(p);float a=atan(p.y,p.x);float spikes=pow(abs(cos(a*3.0+t*0.15)),40.0)+pow(abs(sin(a*3.0+t*0.15)),40.0)*0.6;float star=spikes*exp(-r*2.0)+exp(-r*7.0)*1.4;float rings=0.25/(abs(sin(r*14.0-t*1.6))+0.32)*exp(-r*1.1);vec3 col=(0.5+0.5*cos(6.28318*(r*1.4-t*0.18+vec3(0.0,0.33,0.67))))*rings;col+=vec3(1.0,0.95,0.85)*star;col+=(0.5+0.5*cos(6.28318*(a/6.28318*2.0+r-t*0.1+vec3(0.0,0.33,0.67))))*spikes*exp(-r*1.0)*0.5;outColor=vec4(audioPop(col*u_intensity),1.0);}
