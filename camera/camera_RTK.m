
clear 
% close all
clc
exp = '\2022_01_31\'

path = 'H:\My Drive\dark 2022\2022_01_31\hull\hull_Reorder\'
% path = 'J:\My Drive\dark 2022\2023_08_09_60ms\hull\hull_Reorder\'
save_dir = sprintf('G:/My Drive/%s/',exp)
save_camera_matrices = [save_dir,'camera'];
easyWand_name = '1+2_31_01_2022_skip5_easyWandData'
% easyWand_name = '10_8_23_allmovs_easyWandData'
load([path,easyWand_name])
mkdir([save_dir])
mkdir(save_camera_matrices)
camvec = [2,3,4,1]%
mesh = pcread('G:\My Drive\2022_01_31\3d_data\mov15_frame210.ply');
fly = mesh.Location;


% fly2 = [fly[:,0],fly[:,2],fly[:,1]]

rotation_matrices = easyWandData.rotationMatrices
translation_vectors = easyWandData.translationVector

focal_length = easyWandData.focalLengths;
principal_point = reshape(easyWandData.principalPoints,2,4);
idx = 1

phi = pi
rot = [[1,0,0];[0,cos(phi),-sin(phi)];[0,sin(phi),cos(phi)]];
    Rd = [1,0,0;0,0,1;0,1,0];
rot_try = [ 1.0000   -0.0013   -0.0026;-0.0013   -1.0000    0.0000;   -0.0026    0.0000   -1.0000]

for i = camvec
    coefs = easyWandData.coefs(:,i);
    camera_name = sprintf('/camera%d_KRT',idx)
    H=[coefs(1),coefs(2),coefs(3);coefs(5),coefs(6),coefs(7);coefs(9),coefs(10),coefs(11)];
    h=[coefs(4);coefs(8);1];
    Rz = [-1,0,0;0,-1,0;0,0,1];
    X0 = -inv(H)*h;
    [R,K] = qr(inv(H));
    K=inv(K);
    K = K*Rz/K(3,3);
    % R = R'
    % R(:,2:3) = -R(:,2:3)
    R = (Rz*R')

    if idx == 4
        R=R'
    end
    

    ax = R(:,1)';
    axang = [ax pi];
    rotm = axang2rotm(axang)   ;  

    R2 = R*rotm

%     axang2 = [axz pi/2];
%     rotm2 = axang2rotm(axang2)   ;  

    % % X0 = rotm * X0

%     R = (rotm*R)
    DLT = [K*R,-K*R*X0];
    DLT = DLT /DLT(3,4);
    T(idx,1:3) = X0;
    T2(idx,1:3) = (R*X0)';

    T_plot{idx} = R*X0
    R_plot{idx} = R;
    p = reshape([coefs;1],4,3)';

    % T might be X0 , for now R*X0
    writematrix([K;R2;(-R*X0)'],[save_camera_matrices,camera_name]);
idx = idx+ 1
end
%%
figure
plot3(fly(:,1)*10,fly(:,2)*10,fly(:,3)*10,'.');hold on;axis equal
clr = {'r','g','b'}



for j = 1
    for k = 1:1:3
quiver3(T_plot{j}(1),T_plot{j}(2),T_plot{j}(3),R_plot{j}(1,k),R_plot{j}(2,k),R_plot{j}(3,k),0.1,color = clr{k})
    end
end





