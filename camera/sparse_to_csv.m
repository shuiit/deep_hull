frames





exp = '\2022_01_31\'
mov = 15
path = 'H:\My Drive\dark 2022\2022_01_31\hull\hull_Reorder\'
save_dir = 'H:\My Drive\Roni\'
save_frames_matrices = [save_dir,exp,'2dframes'];
mkdir(save_frames_matrices)


frames_rebuild = struct2cell(frames)';
for i = 1:1:length(frames_rebuild)
    add_frame_num = ones(1,size(frames_rebuild{i},1))*(i-1);
    frames_rebuild{i}(:,3) = int16(frames_rebuild{i}(:,3)/256);
    frames_rebuild{i} = [frames_rebuild{i},add_frame_num'];
end
file_name_frames = sprintf('2dframes_mov%d.csv',mov)
writematrix(cell2mat(frames_rebuild)',[save_frames_matrices,file_name_frames])