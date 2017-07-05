%%%% vfa t1-map
%dependencies: spm, coregister, do_coregister, t1_calc

clear all; close all;

choice=do_coregister;

selected_dirs=spm_select(Inf,'dir','select subject directory');
NRUN = size(selected_dirs,1);

imgscell=cell(NRUN,1);
for i=1:NRUN
    lista=cell(3,1);
    lista{1}=char(my_rdir([selected_dirs(i,:),'**/gre_4*/gre*nii']));
    lista{2}=char(my_rdir([selected_dirs(i,:),'**/gre_18*/gre*nii']));
    lista{3}=char(my_rdir([selected_dirs(i,:),'**/rf_map*/rfmaps*2.nii']));
    
    imgscell{i}=spm_vol(char(strcat(lista,',1')));
end

for i=1:NRUN
imgs=imgscell{i};

% % %set unknown b1 values to NaN
% % b1_img=spm_read_vols(imgs(3));
% % b1_img(b1_img==0)=NaN;
% % spm_write_vol(imgs(3),b1_img);


if(strcmp(choice,'coregister'))
    %coregister estimate and reslice 2nd FLASH
    imgs(2)=coregister(imgs(1).fname,imgs(2).fname,1);
    %coregister est&reslice RF-Map
    imgs(3)=coregister(imgs(1).fname,imgs(3).fname,1,0);
    %%%% smooth rf map
    imgs(3)=smooth(imgs(3).fname,10,1);
elseif(strcmp(choice,'reslice'))
    %coregister RESLICE RF-Map
    imgs(3)=coregister(imgs(1).fname,imgs(3).fname,0,0);
    %%%% smooth rf map
    imgs(3)=smooth(imgs(3).fname,10,1);
end

%read preprocessed files
img1=spm_read_vols(imgs(1));
img2=spm_read_vols(imgs(2));
b1_img=spm_read_vols(imgs(3));

mask=1; %use mask?
if(mask)
mask=(mat2gray(img1)>(graythresh(img1)*0.1));
se = strel('disk',10);
closeBW = imclose(mask,se);
img1(~mask)=NaN;
img2(~mask)=NaN;
b1_img(~mask)=NaN;
end

%t1map=t1_wrapper(img1(:,:,80),img2(:,:,80)); %%% fitting routine (v. slow)
%t1map=t1_poly(img1(:,:,:),img2(:,:,:));    %%% polyval (moderate slow)
[t1map,pdmap]=t1_calc(img1(:,:,:),img2(:,:,:)); 

%%%% b1 correction
b1_img(b1_img==0)=NaN;
b1_deg=zeros(size(b1_img));
b1_deg(b1_img>2048)=(b1_img(b1_img>2048)-2048)*180/2048;
b1_r=b1_deg/90;
t1map_c=t1map./(b1_r.^2);
pdmap_c=pdmap./b1_r;

%%%% spoiling correction (?) -> Preibisch 2009
A=275*b1_r.^2-359*b1_r+142; %[ms]
B=-0.33*b1_r.^2+0.25*b1_r+0.92;
t1map_c2=A+B.*t1map_c;

subplot(1,3,1); imshow(pdmap(:,:,80),[]); title('Proton density');
subplot(1,3,2); imshow(t1map_c2(:,:,80),[300 3000]); title('T1 map');
subplot(1,3,3); imshowpair(img1(:,:,80),mask(:,:,80)); title('mask');


%%%% writing
VO = imgs(1); % copy info from gre_1
[pth, bnm, ext] = spm_fileparts(VO.fname);
VO.fname = fullfile(pth, ['pdmap' ext]);
spm_write_vol(VO,pdmap_c);
VO.fname = fullfile(pth, ['b1map' ext]);
spm_write_vol(VO,b1_deg);
VO.fname = fullfile(pth, ['t1map' ext]);
spm_write_vol(VO,t1map_c2);
if(exist('mask','var'))
    VO.fname = fullfile(pth, ['mask' ext]);
    spm_write_vol(VO,mask);
end

end
