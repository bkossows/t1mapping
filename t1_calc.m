function [t1 pd] = t1_calc(img1,img2)
[x,y,z]=size(img1);
fa=[4,18];
TR=7.6;
fa_r=fa*pi/180;
%create vectors
    x1=img1*fa_r(1);
    x2=img2*fa_r(2);
    y1=img1/fa_r(1);
    y2=img2/fa_r(2);
%do the math
t1=(y1-y2)./(x1-x2);
t1=-t1*2*TR;
pd=(y1.*x2-y2.*x1)./(x2-x1);

%reject rubbish
t1(t1<0 | t1>1e4)=NaN;
end

