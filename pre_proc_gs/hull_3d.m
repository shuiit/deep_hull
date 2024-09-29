%% load hull
clear 
close all
clc

exp = '2022_03_03'
path = 'H:\My Drive\dark 2022\2022_03_03\hull\hull_Reorder\'
easyWand_name = '3+4_post_03_03_2022_skip5_easyWandData.mat'
movie = 19
mov_name = sprintf('mov%d',movie)
struct_file_name = sprintf('\\Shull_mov%d',movie)
load([path,mov_name,'\hull_op\',struct_file_name])

hull3d_file_name = sprintf('\\hull3d_mov%d',movie)
load([path,mov_name,'\hull_op\',hull3d_file_name])

save_dir = sprintf('G:/My Drive/%s/',exp)
save_camera_matrices = [save_dir,'camera'];
save_3d_hull = [save_dir,'3d_data/'];
save_2d_data = [save_dir,'2d_data/'];

mkdir([save_dir])
mkdir(save_camera_matrices)
mkdir(save_3d_hull)
mkdir(save_2d_data)

% load sparse

for cam = 1:1:4
sparse_file = sprintf('\\mov%d_cam%d_sparse.mat',movie,cam)
sp{cam} = load([path,mov_name,sparse_file])
end
%%



frame_sparse = 500;
frame = find(Shull.frames == frame_sparse);
body = hull3d.body.body4plot{frame};
wing_left = hull3d.leftwing.hull.hull3d{frame};
wing_right = hull3d.rightwing.hull.hull3d{frame};


real_coords = Shull.real_coord{frame}
body_3d = [real_coords{1}(body(:,1))',real_coords{2}(body(:,2))',real_coords{3}(body(:,3))']
wing_left_3d = [real_coords{1}(wing_left(:,1))',real_coords{2}(wing_left(:,2))',real_coords{3}(wing_left(:,3))']
wing_right_3d = [real_coords{1}(wing_right(:,1))',real_coords{2}(wing_right(:,2))',real_coords{3}(wing_right(:,3))']

fly = [body_3d;wing_left_3d;wing_right_3d];
writematrix(fly,[save_3d_hull,'fly']);
%% lab axes
load([path,easyWand_name])
figure
clr = {'r','g','b','m'}

for j = 1:1:4
[R,K,X0] = decompose_dlt(easyWandData.coefs(:,j));
length_arr = 0.2
if j == 1
    R = R'
    length_arr = 0.3;
end

R = -Shull.rotmat_EWtoL*R;
t = Shull.rotmat_EWtoL*X0;
for k = 1:1:3
    if k == 3
        quiverHandles(k) = quiver3(t(1),t(2),t(3),R(1,k),R(2,k),R(3,k),length_arr,color = clr{k});hold on
    else
        quiverHandles(k) = quiver3(t(1),t(2),t(3),R(1,k),R(2,k),R(3,k),0.1,color = clr{k});hold on
    end
end
scatterHandles(j) = scatter3(t(1),t(2),t(3),30,'filled', clr{j});hold on

end
fly_lab = (Shull.rotmat_EWtoL*fly')';
hold on;scatter3(fly_lab(:,1),fly_lab(:,2),fly_lab(:,3),'.');axis equal
hold on;scatter3(0,0,0,1000,'.r');axis equal
legend([quiverHandles,scatterHandles], {'x', 'y', 'z','cam1','cam2','cam3','cam4'});
xlabel('x');ylabel('y');zlabel('z')
title('Lab')
%%
figure
for j = 1:1:4
[R,K,X0] = decompose_dlt(easyWandData.coefs(:,j));
if j == 1
R = R';
end

% Define the camera axes in world coordinates (columns of R are the axes)
X_cam = R(:,1);  % X-axis of the camera in world coordinates
Y_cam = R(:,2);  % Y-axis of the camera in world coordinates
Z_cam = R(:,3);  % Z-axis of the camera in world coordinates

% Define the scale for visualizing the axes
scale = 0.1;

% Plot the camera position (X0) in world coordinates
;
hold on;
grid on;
axis equal;
plot3(X0(1), X0(2), X0(3), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k'); % Camera center

% Plot the camera's X, Y, Z axes using quiver3
quiver3(X0(1), X0(2), X0(3), scale*X_cam(1), scale*X_cam(2), scale*X_cam(3), 'r', 'LineWidth', 2); % X-axis (red)
quiver3(X0(1), X0(2), X0(3), scale*Y_cam(1), scale*Y_cam(2), scale*Y_cam(3), 'g', 'LineWidth', 2); % Y-axis (green)
quiver3(X0(1), X0(2), X0(3), scale*Z_cam(1), scale*Z_cam(2), scale*Z_cam(3), 'b', 'LineWidth', 2); % Z-axis (blue)

% Label the axes
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Camera in World Coordinates');

hold off;
end

%% easywand axes
load([path,easyWand_name])
figure
Ralign = [1 0 0 ;0 1 0 ;0 0 1]
clr = {'r','g','b','m'}

for j = 1:1:4
[R1,K,X0] = decompose_dlt(easyWandData.coefs(:,j));
if j == 1

    R1 = R1
    X0 = -X0;
end


R = R1'*Ralign;
t = X0;
rot = easyWandData.rotationMatrices(:,:,j)';
trans = rot*easyWandData.translationVector(:,:,j)';
pm{j} = [K*R1,-K*R1*X0]; % R - world to camera, X0 - location in world. R - rotate to camera 

r_colmap = R1'
t_colmap = X0;



% pm{j} = pm{j}/pm{j}(3,4)
for k = 1:1:3
quiver3(t_colmap(1),t_colmap(2),t_colmap(3),r_colmap(1,k),r_colmap(2,k),r_colmap(3,k),0.1,color = clr{k});hold on
% quiver3(trans(1),trans(2),trans(3),rot(1,k),rot(2,k),rot(3,k),0.1,color = clr{k});hold on
scatter3(t_colmap(1),t_colmap(2),t_colmap(3),30,'filled', clr{j});hold on
end
end
scatter3(0,0,0,100,'filled', clr{j});hold on

hold on;scatter3(10*fly(:,1),10*fly(:,2),10*fly(:,3),'.');axis equal
xlabel('x');ylabel('y');zlabel('z')
title('Easywand')

%%


figure
for j = 1:1:4
[R,K,X0] = decompose_dlt(easyWandData.coefs(:,j));
if j == 1
    R = R'
end

R = R*Ralign;
t = +X0;
subplot(2,2,j)

fly_cam = (R'*fly' + R'*X0)';
hold on;scatter3(fly_cam(:,1),fly_cam(:,2),fly_cam(:,3),'.');axis equal; xlabel('x');ylabel('y');zlabel('z')
ttl = sprintf('cam%d',j)
title(ttl)
R_world = R';
t_world = + R'*X0; % check with I
for k = 1:1:3
quiver3(t_world(1),t_world(2),t_world(3),R_world(1,k),R_world(2,k),R_world(3,k),0.01,color = clr{k});hold on
scatter3(t_world(1),t_world(2),t_world(3),30,'filled', clr{j});hold on
end
end



%%
cam = 1

fly_h = [fly,ones(size(fly,1),1)]
pt2d = pm{cam}*fly_h';
pt2d =( pt2d./pt2d(3,:))'


im = ImfromSp([800,1280],sp{cam}.frames(frame_sparse).indIm);
figure
[uv] = dlt_inverse(easyWandData.coefs(:,cam),fly)
imshow(im);hold on

scatter(uv(:,1),801-uv(:,2));hold on

% scatter(uv(:,1),uv(:,2));hold on

scatter(pt2d(:,1),801-pt2d(:,2),'r.')



