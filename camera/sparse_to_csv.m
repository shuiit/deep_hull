frames


saveobj('your_data.pkl', frames);

% Open the HDF5 file in write mode
fid = H5E('your_data.h5','w');

h5save('your_data.h5', '/data_struct', struct2cell(frames));



frames_rebuild = struct2cell(frames)';
for i = 1:1:length(frames_rebuild)
    add_frame_num = ones(1,size(frames_rebuild{i},1))*(i-1);
    frames_rebuild{i} = [frames_rebuild{i},add_frame_num'];
end

% csvwrite(cell2mat(frames_rebuild');)