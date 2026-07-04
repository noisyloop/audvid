// name: SUPERFORMULA
// category: geometric
// ported from prism-video-synth
float superR(float a,float m,float n1,float n2,float n3){float t1=pow(abs(cos(m*a*0.25)),n2);float t2=pow(abs(sin(m*a*0.25)),n3);return pow(max(t1+t2,1e-6),-1.0/n1);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;vec2 p=uv*2.4*u_scale;float r=length(p);float a=atan(p.y,p.x);vec3 col=vec3(0.015,0.01,0.04);for(int i=0;i<3;i++){float fi=float(i);float m=3.0+2.0*floor(mod(t*0.15+fi*0.37,4.0));float n1=mix(0.3,2.5,0.5+0.5*sin(t*0.4+fi*2.0));float n2=mix(0.5,2.0,0.5+0.5*sin(t*0.31+fi));float R=superR(a+t*0.1*(fi-1.0),m,n1,n2,n2)*(0.55+fi*0.22);float d=abs(r-R);col+=(0.5+0.5*cos(6.28318*(fi*0.22+R*0.4+t*0.07+vec3(0.0,0.33,0.67))))*(smoothstep(0.02,0.0,d-0.004)+0.006/(d+0.018))*0.7;}col+=vec3(0.9,0.8,1.0)*exp(-r*5.0)*0.3;outColor=vec4(audioPop(col*u_intensity),1.0);}
