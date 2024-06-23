

exp = '\2022_01_31\'

path = 'H:\My Drive\dark 2022\2022_01_31\hull\hull_Reorder\'
save_dir = 'H:\My Drive\Roni\'
save_camera_matrices = [save_dir,exp,'camera'];
easyWand_name = '1+2_31_01_2022_skip5_easyWandData'
mkdir([save_dir,exp])
mkdir(save_camera_matrices)

rotation_matrices = easyWandData.rotationMatrices
translation_vectors = easyWandData.translationVector

focal_length = easyWandData.focalLengths;
principal_point = reshape(easyWandData.principalPoints,2,4);

for i = 1:1:4
    camera_name = sprintf('/camera%d_KRT',i)
    K = [focal_length(i), 0, principal_point(1,i);0, focal_length(i), principal_point(2,i);0, 0, 1];
    R = rotation_matrices(:,:,i);
    T = rotation_matrices(:,:,i);
    writematrix([K;R;T],[save_camera_matrices,camera_name])
    
end

