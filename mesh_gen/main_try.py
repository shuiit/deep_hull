from scipy import io
import numpy as np
import pandas as pd
import open3d as o3d

path = 'J:\My Drive\Roni\csv_mov'
mov = 'mov15'
files_to_load = [f'hull_data_{mov}',f'real_coords_{mov}','rot_mat']

# load data to dictionary
data_dict = {file_to_load : pd.read_csv(f'{path}\{file_to_load}.csv') for file_to_load in files_to_load}



# load body and wing data to dictionary
name_of_parts = ['body','wing_l','wing_r']
fly_hull = {name_of_part : data_dict[files_to_load[0]].query(f'{name_of_part} == 1')[['x','y','z']] for name_of_part in name_of_parts}
# load real coordinates
real_coord = {ax: data_dict[files_to_load[1]].query(f'{ax} == 1')['real_coords'].reset_index(drop = True) for ax in ['x','y','z']}

# rotate and save the hull in lab axes
rot_mat = data_dict['rot_mat'].to_numpy()
real_hull = {body_wing : np.dot(rot_mat,np.vstack([real_coord[ax][fly_hull[body_wing][ax]] for ax in ['x','y','z']])).T for body_wing in name_of_parts}

rwing = real_hull['wing_r'][0:100,:]
pcd = o3d.geometry.PointCloud()

pcd.points = o3d.utility.Vector3dVector(rwing)
