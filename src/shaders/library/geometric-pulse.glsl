// name: GEOMETRIC PULSE
// category: geometric
// ported from prism-video-synth
float sdBox(vec2 p,vec2 b){vec2 d=abs(p)-b;return length(max(d,0.0))+min(max(d.x,d.y),0.0);}mat2 rot(float a){float c=cos(a),s=sin(a);return mat2(c,-s,s,c);}void main(){vec2 uv=gl_FragCoord.xy/u_res.xy;vec2 p=(uv-0.5)*u_scale;p.x*=u_res.x/u_res.y;float t=u_time*u_speed;vec3 col=vec3(0.02,0.02,0.05);for(float i=0.0;i<8.0;i++){float fi=i/8.0;float sc=0.3-fi*0.03;float rs=(mod(i,2.0)==0.0?1.0:-1.0)*0.5;vec2 pp=p*rot(t*rs+fi*3.14159);float d=sdBox(pp,vec2(sc));float pulse=sin(t*3.0+fi*6.28318)*0.02;float line=smoothstep(0.01,0.0,abs(d+pulse)-0.005);vec3 sc2=0.5+0.5*cos(6.28318*(fi+vec3(0.0,0.33,0.67)+t*0.2));col+=sc2*line*u_intensity+sc2*0.02/(abs(d)+0.02)*0.1*u_intensity;}outColor=vec4(col,1.0);}
