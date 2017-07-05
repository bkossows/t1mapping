function img=fillgaps(img)
[X,Y,Z]=meshgrid(1:size(img,1),1:size(img,2),1:size(img,3));
img=griddata(X(~isnan(img)),Y(~isnan(img)),Z(~isnan(img)),img(~isnan(img)),X,Y,Z,'natural');
end
