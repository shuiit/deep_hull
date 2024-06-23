clear 
close all
clc


path = 'H:\My Drive\dark 2022\2022_01_31\hull\hull_Reorder\'
save_dir = 'H:\My Drive\Roni\'
movie = 15
mov_name = sprintf('mov%d',movie)
file_name = sprintf('hull3d_mov%d',movie)
struct_file_name = sprintf('Shull_mov%d',movie)
save_file = sprintf('hull_data_mov%d.csv',movie)
path_to_use = [path,mov_name,'/hull_op/']
path_to_save = [save_dir,'/csv_mov/']
load([path_to_use,file_name])
load([path_to_use,struct_file_name])
mkdir(path_to_save)

%%

frame = 210
body = hull3d.body.body4plot{frame};
wing_left = hull3d.leftwing.hull.hull3d{frame};
wing_right = hull3d.rightwing.hull.hull3d{frame};

wing_left_bound = [hull3d.leftwing.hull.LE{frame};hull3d.leftwing.hull.TE{frame}];
wing_right_bound = [hull3d.rightwing.hull.LE{frame};hull3d.rightwing.hull.TE{frame}];
rot_mat = Shull.rotmat_EWtoL;
real_coords = Shull.real_coord{frame};

hull_data = [body;wing_left;wing_right]

body_left_wing_right_wing = hull_data*0;
body_left_wing_right_wing(1:size(body,1),1) = 1;
body_left_wing_right_wing(size(body,1) + 1:size(body,1) + size(wing_left,1),2) = 1;
body_left_wing_right_wing(size(body,1) + size(wing_left,1):end,3) = 1;


hull_data = [hull_data,body_left_wing_right_wing]

T = array2table(hull_data)
T.Properties.VariableNames = {'x','y','z','body','wing_l','wing_r'}
writetable(T,[path_to_save,save_file])
pcshow(wing_right);hold on;pcshow(wing_left)

%%


real_coords = Shull.real_coord{frame}
body_3d = [real_coords{1}(body(:,1))',real_coords{2}(body(:,2))',real_coords{3}(body(:,3))']
body_real = Shull.rotmat_EWtoL*body_3d'

xyz = zeros(length(cell2mat(real_coords')),3);

xyz(1:length(real_coords{1}),1) = 1;
xyz(length(real_coords{1}) + 1:length(real_coords{1}) + length(real_coords{2}),2) = 1;
xyz(length(real_coords{2}) + length(real_coords{1}) + 1:end,3) = 1;


real_coords_table = array2table([cell2mat(real_coords')',xyz])
real_coords_table.Properties.VariableNames = {'real_coords','x','y','z'}
save_file = sprintf('real_coords_mov%d.csv',movie)

writetable(real_coords_table,[path_to_save,save_file])


rot_mat_table = array2table(rot_mat)
rot_mat_table.Properties.VariableNames = {'x','y','z'}
writetable(rot_mat_table,[path_to_save,'\rot_mat.csv'])
pcshow(wing_right);hold on;pcshow(wing_left)

normals = array2table([Shull.rightwing.vectors.nrml(frame,:);Shull.leftwing.vectors.nrml(frame,:)])
normals.Properties.VariableNames = {'x','y','z'}
writetable(normals,[path_to_save,'\wing_normals.csv'])


%%


% ptCloudIn = pointCloud(body_real')
% [mesh,depth,perVertexDensity] = pc2surfacemesh(ptCloudIn,"poisson",12)
% surfaceMeshShow(mesh)
% 



