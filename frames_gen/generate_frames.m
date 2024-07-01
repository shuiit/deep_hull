
exp = '\2022_01_31\'
path = 'H:\My Drive\dark 2022\2022_01_31\hull\hull_Reorder\'
save_dir = 'G:\My Drive\'
movie = 15


movie_name = sprintf('\\mov%d',movie)
movie_path = [path,movie_name]
save_frame = [save_dir,exp,'2d_data\'];
mkdir(save_frame);

cams = [1,2,3,4]
cam_up = 4
files = dir(movie_path);idx = 1;
for j = 1:1:length(files)
    if contains(files(j).name,'sparse')
        sparse_name{idx} = files(j).name;
        idx = idx + 1;
    end
end


for idx = 1:1:4
    file_name = sprintf('cam%d_mov%d.mat',idx,movie)
    load([movie_path,'\',sparse_name{idx}]);
    
    
    frames = struct2cell(frames)';
    for j = 1:1: length(frames)
        val_frames{j} = uint8(frames{j}(:,3)/256);
        frames{j}(:,3) = j-1;
        frames{j}(:,1) = frames{j}(:,1) - 1;

        if idx == cam_up
        frames{j}(:,1) = 799 - frames{j}(:,1);
        end

        frames{j} = frames{j}(:,1:3);
        frames{j}(:,1:2) = fliplr(frames{j}(:,1:2));
        
    end
    m = cell2mat(frames);
    save([save_frame,'\','location_',file_name],'m')
    
    m = cell2mat(val_frames');
    save( [save_frame,'\','value_',file_name],'m')
end






