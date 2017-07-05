function option = do_coregister
choice = questdlg('Coregister the images?', ...
	'T1-mapping', ...
	'Coregister, Reslice (all) and Smooth (RF-Map)','Only reslice&smooth RF-Map','No','No');
% Handle response
switch choice
    case 'Coregister, Reslice (all) and Smooth (RF-Map)'
        disp([choice ' coming right up.'])
        option = 'coregister';
    case 'Only reslice&smooth RF-Map'
        disp([choice ' coming right up.'])
        option = 'reslice';
    case 'No'
        disp('Going straight to calculations')
        option = 0;
end
end