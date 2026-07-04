// name: ENNEAGRAM
// category: sacred
// ported from prism-video-synth
vec2 pt(float i){float a=i/9.0*6.28318-1.5708;return vec2(cos(a),sin(a));}
vec3 seg(vec2 p,float i,float j,float t){vec2 a=pt(i),b=pt(j);vec2 pa=p-a,ba=b-a;float h=clamp(dot(pa,ba)/dot(ba,ba),0.0,1.0);float d=length(pa-ba*h);vec3 c=(0.5+0.5*cos(6.28318*(i/9.0+t*0.08+vec3(0.0,0.33,0.67))));float pulse=exp(-pow((h-fract(t*0.4+i*0.11))*5.0,2.0));return c*(smoothstep(0.012,0.0,d)*0.6+pulse*exp(-d*60.0)*1.2);}
void main(){vec2 uv=(gl_FragCoord.xy-u_res.xy*0.5)/u_res.y;float t=u_time*u_speed;float ca=cos(t*0.06),sa=sin(t*0.06);vec2 p=mat2(ca,-sa,sa,ca)*uv*2.4/max(u_scale,0.1);vec3 col=vec3(0.01,0.0,0.03);col+=seg(p,1.0,4.0,t)+seg(p,4.0,2.0,t)+seg(p,2.0,8.0,t)+seg(p,8.0,5.0,t)+seg(p,5.0,7.0,t)+seg(p,7.0,1.0,t);col+=seg(p,3.0,6.0,t)+seg(p,6.0,9.0,t)+seg(p,9.0,3.0,t);float ring=abs(length(p)-1.0);col+=(0.5+0.5*cos(6.28318*(atan(p.y,p.x)/6.28318+t*0.1+vec3(0.0,0.33,0.67))))*(smoothstep(0.012,0.0,ring)+0.005/(ring+0.02));for(int i=0;i<9;i++){float fi=float(i)+1.0;float nd=length(p-pt(fi));col+=vec3(1.0,0.95,0.85)*exp(-nd*40.0)*(0.6+0.4*sin(t*2.0+fi));}outColor=vec4(audioPop(col*u_intensity),1.0);}
