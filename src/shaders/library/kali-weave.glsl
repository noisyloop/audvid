// name: KALI WEAVE
// category: fractal
// ported from prism-video-synth
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*1.6*u_scale;vec2 c=vec2(0.85+0.1*sin(t*0.37),0.58+0.1*cos(t*0.43));float acc=0.0;float w=1.0;float trap=1e9;for(int i=0;i<13;i++){p=abs(p)/max(dot(p,p),1e-6)-c;acc+=w*exp(-3.5*abs(length(p)-0.45));trap=min(trap,length(p));w*=0.92;}acc*=0.34;vec3 col=(0.5+0.5*cos(6.28318*(acc*0.6+trap*0.3+t*0.07+vec3(0.0,0.33,0.67))))*acc;col+=vec3(0.9,0.5,1.0)*exp(-trap*4.0)*0.5;outColor=vec4(col*u_intensity,1.0);}
